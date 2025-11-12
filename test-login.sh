#!/bin/bash

# Test-Skript für Login Flow
# Testet Login mit und ohne 2FA

echo "🔐 Teste Login Flow..."
echo ""

# Test 1: Login ohne 2FA (wenn 2FA noch nicht aktiviert)
echo "📝 Test 1: Login ohne 2FA..."
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
  echo "✅ 2FA ist aktiviert - tempToken erhalten"
  
  # Extrahiere tempToken
  if command -v jq &> /dev/null; then
    TEMP_TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.tempToken')
  else
    TEMP_TOKEN=$(echo "$LOGIN_RESPONSE" | grep -o '"tempToken":"[^"]*"' | sed 's/"tempToken":"\([^"]*\)"/\1/')
  fi
  
  if [ -n "$TEMP_TOKEN" ] && [ "$TEMP_TOKEN" != "null" ]; then
    echo "tempToken: ${TEMP_TOKEN:0:30}..."
    echo ""
    echo "📱 Nächster Schritt: Verwende dieses tempToken für /api/login/2fa"
    echo ""
    echo "Beispiel:"
    echo "curl -s -X POST http://localhost:3000/api/login/2fa \\"
    echo "  -H \"Authorization: Bearer $TEMP_TOKEN\" \\"
    echo "  -H \"Content-Type: application/json\" \\"
    echo "  -d '{\"token\":\"123456\"}'"
  fi
elif echo "$LOGIN_RESPONSE" | grep -q '"access"'; then
  echo "✅ Login erfolgreich - Access Token erhalten"
  
  # Extrahiere access token
  if command -v jq &> /dev/null; then
    ACCESS_TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.access')
    echo "Access Token: ${ACCESS_TOKEN:0:30}..."
    echo ""
    echo "📋 Du kannst dieses Token für /api/session/me verwenden:"
    echo ""
    echo "curl -s -X GET http://localhost:3000/api/session/me \\"
    echo "  -H \"Authorization: Bearer $ACCESS_TOKEN\""
  fi
else
  echo "⚠️  Login fehlgeschlagen oder unerwartete Antwort"
  echo ""
  echo "Mögliche Gründe:"
  echo "  - E-Mail oder Passwort falsch"
  echo "  - Benutzer existiert nicht"
  echo "  - Datenbank-Fehler"
fi

echo ""
echo "✅ Test abgeschlossen!"

