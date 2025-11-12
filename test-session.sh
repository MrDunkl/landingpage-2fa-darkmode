#!/bin/bash

# Test-Skript für Session/Me Route
# Testet die Authentifizierung mit Access Token

echo "🔐 Teste Session/Me Route..."
echo ""

# Option 1: Verwende vorhandenes Access Token aus localStorage (wenn im Browser)
echo "📝 Option 1: Manuelles Access Token"
echo ""
echo "Du kannst ein Access Token auf folgende Weise erhalten:"
echo "  1. Durch Login ohne 2FA:"
echo "     curl -s -X POST http://localhost:3000/api/login \\"
echo "       -H \"Content-Type: application/json\" \\"
echo "       -d '{\"email\":\"test@example.com\",\"password\":\"superlangesPasswort123!\"}'"
echo ""
echo "  2. Durch Login mit 2FA:"
echo "     curl -s -X POST http://localhost:3000/api/login/2fa \\"
echo "       -H \"Authorization: Bearer TEMP_TOKEN\" \\"
echo "       -H \"Content-Type: application/json\" \\"
echo "       -d '{\"token\":\"123456\"}'"
echo ""

# Option 2: Automatischer Test (Login -> Session/Me)
echo "📝 Option 2: Automatischer Test (Login -> Session/Me)"
echo ""

# Schritt 1: Login
echo "Schritt 1: Login..."
LOGIN_RESPONSE=$(curl -s -X POST http://localhost:3000/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"superlangesPasswort123!"}')

echo "Login Response:"
if command -v jq &> /dev/null; then
  echo "$LOGIN_RESPONSE" | jq '.'
else
  echo "$LOGIN_RESPONSE"
fi
echo ""

# Extrahiere Access Token
if command -v jq &> /dev/null; then
  ACCESS_TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.access // empty')
else
  ACCESS_TOKEN=$(echo "$LOGIN_RESPONSE" | grep -o '"access":"[^"]*"' | sed 's/"access":"\([^"]*\)"/\1/')
fi

# Wenn kein Access Token (2FA erforderlich), versuche mit tempToken
if [ -z "$ACCESS_TOKEN" ] || [ "$ACCESS_TOKEN" = "null" ]; then
  echo "ℹ️  2FA ist aktiviert, benötige tempToken..."
  
  if command -v jq &> /dev/null; then
    TEMP_TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.tempToken // empty')
  else
    TEMP_TOKEN=$(echo "$LOGIN_RESPONSE" | grep -o '"tempToken":"[^"]*"' | sed 's/"tempToken":"\([^"]*\)"/\1/')
  fi
  
  if [ -n "$TEMP_TOKEN" ] && [ "$TEMP_TOKEN" != "null" ]; then
    echo "⚠️  Hinweis: Für 2FA benötigst du einen echten TOTP-Code."
    echo "   Verwende: ./test-login-2fa.sh um ein Access Token zu erhalten"
    echo ""
    echo "Oder manuell:"
    echo "  1. Scanne den QR-Code von /api/2fa/setup"
    echo "  2. Verwende den 6-stelligen Code von Google Authenticator"
    echo "  3. Rufe /api/login/2fa auf"
    exit 0
  else
    echo "❌ Fehler: Konnte kein Access Token oder tempToken erhalten"
    exit 1
  fi
fi

if [ -z "$ACCESS_TOKEN" ] || [ "$ACCESS_TOKEN" = "null" ]; then
  echo "❌ Fehler: Konnte kein Access Token erhalten"
  exit 1
fi

echo "✅ Access Token erhalten: ${ACCESS_TOKEN:0:30}..."
echo ""

# Schritt 2: Session/Me
echo "Schritt 2: Session/Me..."
SESSION_RESPONSE=$(curl -s -X GET http://localhost:3000/api/session/me \
  -H "Authorization: Bearer $ACCESS_TOKEN")

echo "Session Response:"
if command -v jq &> /dev/null; then
  echo "$SESSION_RESPONSE" | jq '.'
else
  echo "$SESSION_RESPONSE"
fi
echo ""

# Prüfe ob erfolgreich
if echo "$SESSION_RESPONSE" | grep -q '"user"'; then
  echo "✅ Session erfolgreich abgerufen!"
  
  if command -v jq &> /dev/null; then
    echo ""
    echo "📋 Benutzer-Daten:"
    echo "$SESSION_RESPONSE" | jq '.user'
  fi
else
  echo "❌ Fehler beim Abrufen der Session"
  echo ""
  echo "Mögliche Gründe:"
  echo "  - Token ist abgelaufen"
  echo "  - Token ist ungültig"
  echo "  - Benutzer existiert nicht mehr"
fi

echo ""
echo "✅ Test abgeschlossen!"

