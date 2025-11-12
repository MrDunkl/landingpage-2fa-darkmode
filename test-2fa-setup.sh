#!/bin/bash

# Test-Skript für 2FA Setup
# Dieses Skript registriert einen Benutzer und testet dann die 2FA Setup Route

echo "📝 Schritt 1: Registrierung..."
REGISTER_RESPONSE=$(curl -s -X POST http://localhost:3000/api/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test'$(date +%s)'@example.com","password":"superlangesPasswort123!","title":"Dr"}')

echo "Register Response: $REGISTER_RESPONSE"

# Extrahiere setupToken (mit jq falls verfügbar, sonst mit sed/grep)
if command -v jq &> /dev/null; then
  SETUP_TOKEN=$(echo "$REGISTER_RESPONSE" | jq -r '.setupToken')
else
  SETUP_TOKEN=$(echo "$REGISTER_RESPONSE" | grep -o '"setupToken":"[^"]*"' | sed 's/"setupToken":"\([^"]*\)"/\1/')
fi

if [ -z "$SETUP_TOKEN" ] || [ "$SETUP_TOKEN" = "null" ]; then
  echo "❌ Fehler: Konnte kein setupToken erhalten"
  echo "Bitte stelle sicher, dass:"
  echo "  1. Die Datenbank konfiguriert ist (DATABASE_URL in .env)"
  echo "  2. Die Migration ausgeführt wurde: npx prisma migrate dev"
  echo "  3. Der Server läuft: npm run dev"
  exit 1
fi

echo ""
echo "✅ setupToken erhalten: ${SETUP_TOKEN:0:20}..."
echo ""
echo "📱 Schritt 2: 2FA Setup..."
echo ""

curl -s -X POST http://localhost:3000/api/2fa/setup \
  -H "Authorization: Bearer $SETUP_TOKEN" \
  -H "Content-Type: application/json" | jq '.' 2>/dev/null || \
curl -s -X POST http://localhost:3000/api/2fa/setup \
  -H "Authorization: Bearer $SETUP_TOKEN" \
  -H "Content-Type: application/json"

echo ""
echo ""
echo "✅ Test abgeschlossen!"

