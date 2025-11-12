#!/bin/bash

# Test-Skript für den vollständigen 2FA Flow
# Register -> Setup -> Verify

echo "🔐 Teste vollständigen 2FA Flow..."
echo ""

# Schritt 1: Registrierung
echo "📝 Schritt 1: Registrierung..."
EMAIL="test$(date +%s)@example.com"
REGISTER_RESPONSE=$(curl -s -X POST http://localhost:3000/api/register \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$EMAIL\",\"password\":\"superlangesPasswort123!\",\"title\":\"Dr\"}")

echo "Register Response: $REGISTER_RESPONSE"
echo ""

# Extrahiere setupToken
if command -v jq &> /dev/null; then
  SETUP_TOKEN=$(echo "$REGISTER_RESPONSE" | jq -r '.setupToken')
  USER_ID=$(echo "$REGISTER_RESPONSE" | jq -r '.userId')
else
  SETUP_TOKEN=$(echo "$REGISTER_RESPONSE" | grep -o '"setupToken":"[^"]*"' | sed 's/"setupToken":"\([^"]*\)"/\1/')
  USER_ID=$(echo "$REGISTER_RESPONSE" | grep -o '"userId":"[^"]*"' | sed 's/"userId":"\([^"]*\)"/\1/')
fi

if [ -z "$SETUP_TOKEN" ] || [ "$SETUP_TOKEN" = "null" ]; then
  echo "❌ Fehler: Konnte kein setupToken erhalten"
  echo "Bitte stelle sicher, dass:"
  echo "  1. Die Datenbank konfiguriert ist (DATABASE_URL in .env)"
  echo "  2. Die Migration ausgeführt wurde: npx prisma migrate dev"
  echo "  3. Der Server läuft: npm run dev"
  exit 1
fi

echo "✅ setupToken erhalten: ${SETUP_TOKEN:0:30}..."
echo ""

# Schritt 2: 2FA Setup (QR Code generieren)
echo "📱 Schritt 2: 2FA Setup (QR Code generieren)..."
SETUP_RESPONSE=$(curl -s -X POST http://localhost:3000/api/2fa/setup \
  -H "Authorization: Bearer $SETUP_TOKEN" \
  -H "Content-Type: application/json")

echo "Setup Response: $SETUP_RESPONSE"
echo ""

# Extrahiere otpauthUrl für manuelle Code-Generierung
if command -v jq &> /dev/null; then
  OTPAUTH_URL=$(echo "$SETUP_RESPONSE" | jq -r '.otpauthUrl')
  QR_DATA_URL=$(echo "$SETUP_RESPONSE" | jq -r '.qrDataUrl')
else
  OTPAUTH_URL=$(echo "$SETUP_RESPONSE" | grep -o '"otpauthUrl":"[^"]*"' | sed 's/"otpauthUrl":"\([^"]*\)"/\1/')
fi

if [ -z "$OTPAUTH_URL" ] || [ "$OTPAUTH_URL" = "null" ]; then
  echo "❌ Fehler: Konnte kein otpauthUrl erhalten"
  exit 1
fi

echo "✅ QR Code generiert"
echo "otpauthUrl: $OTPAUTH_URL"
echo ""

# Schritt 3: 2FA Verify
echo "🔍 Schritt 3: 2FA Verify..."
echo "⚠️  Hinweis: Verwende '123456' als Test-Token (normalerweise von Google Authenticator)"
echo ""

VERIFY_RESPONSE=$(curl -s -X POST http://localhost:3000/api/2fa/verify \
  -H "Authorization: Bearer $SETUP_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"token":"123456"}')

echo "Verify Response:"
if command -v jq &> /dev/null; then
  echo "$VERIFY_RESPONSE" | jq '.'
else
  echo "$VERIFY_RESPONSE"
fi

echo ""
echo ""

# Prüfe ob erfolgreich
if echo "$VERIFY_RESPONSE" | grep -q '"enabled":true'; then
  echo "✅ 2FA erfolgreich aktiviert!"
  if command -v jq &> /dev/null; then
    echo ""
    echo "📋 Backup-Codes:"
    echo "$VERIFY_RESPONSE" | jq -r '.backupCodes[]' | nl
  fi
else
  echo "⚠️  Hinweis: Der Test-Token '123456' ist wahrscheinlich ungültig."
  echo "   Verwende einen echten TOTP-Code von Google Authenticator."
  echo "   Du kannst den otpauthUrl oben verwenden, um den QR-Code zu scannen."
fi

echo ""
echo "✅ Test abgeschlossen!"

