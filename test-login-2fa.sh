#!/bin/bash

# Test-Skript für Login mit 2FA Flow
# Login -> 2FA Verify -> Access Token

echo "🔐 Teste Login mit 2FA Flow..."
echo ""

# Schritt 1: Login (erhält tempToken wenn 2FA aktiviert)
echo "📝 Schritt 1: Login..."
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

# Prüfe ob 2FA erforderlich ist
if echo "$LOGIN_RESPONSE" | grep -q '"requires2fa":true'; then
  echo "✅ 2FA ist aktiviert"
  
  # Extrahiere tempToken
  if command -v jq &> /dev/null; then
    TEMP_TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.tempToken')
  else
    TEMP_TOKEN=$(echo "$LOGIN_RESPONSE" | grep -o '"tempToken":"[^"]*"' | sed 's/"tempToken":"\([^"]*\)"/\1/')
  fi
  
  if [ -z "$TEMP_TOKEN" ] || [ "$TEMP_TOKEN" = "null" ]; then
    echo "❌ Fehler: Konnte kein tempToken erhalten"
    exit 1
  fi
  
  echo "✅ tempToken erhalten: ${TEMP_TOKEN:0:30}..."
  echo ""
  
  # Schritt 2: 2FA Verify
  echo "📱 Schritt 2: 2FA Verify..."
  echo "⚠️  Hinweis: Verwende '123456' als Test-Token (normalerweise von Google Authenticator)"
  echo ""
  
  VERIFY_RESPONSE=$(curl -s -X POST http://localhost:3000/api/login/2fa \
    -H "Authorization: Bearer $TEMP_TOKEN" \
    -H "Content-Type: application/json" \
    -d '{"token":"123456"}')
  
  echo "2FA Verify Response:"
  if command -v jq &> /dev/null; then
    echo "$VERIFY_RESPONSE" | jq '.'
  else
    echo "$VERIFY_RESPONSE"
  fi
  echo ""
  
  # Prüfe ob erfolgreich
  if echo "$VERIFY_RESPONSE" | grep -q '"access"'; then
    echo "✅ Login mit 2FA erfolgreich!"
    
    if command -v jq &> /dev/null; then
      ACCESS_TOKEN=$(echo "$VERIFY_RESPONSE" | jq -r '.access')
      echo "Access Token: ${ACCESS_TOKEN:0:30}..."
      echo ""
      echo "📋 Du kannst dieses Token für /api/session/me verwenden:"
      echo ""
      echo "curl -s -X GET http://localhost:3000/api/session/me \\"
      echo "  -H \"Authorization: Bearer $ACCESS_TOKEN\""
    fi
  else
    echo "⚠️  Hinweis: Der Test-Token '123456' ist wahrscheinlich ungültig."
    echo "   Verwende einen echten TOTP-Code von Google Authenticator."
  fi
  
elif echo "$LOGIN_RESPONSE" | grep -q '"access"'; then
  echo "ℹ️  2FA ist nicht aktiviert - direktes Access Token erhalten"
  
  if command -v jq &> /dev/null; then
    ACCESS_TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.access')
    echo "Access Token: ${ACCESS_TOKEN:0:30}..."
  fi
else
  echo "❌ Login fehlgeschlagen"
  echo ""
  echo "Mögliche Gründe:"
  echo "  - E-Mail oder Passwort falsch"
  echo "  - Benutzer existiert nicht"
  echo "  - Datenbank-Fehler"
  exit 1
fi

echo ""
echo "✅ Test abgeschlossen!"

