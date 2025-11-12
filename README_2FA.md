# 2FA Authentication System

Vollständiges 2FA-System mit Next.js 14, Prisma, PostgreSQL, TOTP (Google Authenticator) und JWT.

## Setup

### 1. Dependencies installieren

```bash
npm install
```

### 2. Umgebungsvariablen konfigurieren

Erstelle eine `.env` Datei im Root-Verzeichnis:

```env
DATABASE_URL="postgresql://USER:PASS@HOST:PORT/DB?schema=public"
JWT_SECRET="<generiere-mit-openssl-rand-base64-32>"
```

**JWT_SECRET generieren:**
```bash
openssl rand -base64 32
```

### 3. Datenbank einrichten

```bash
# Prisma Client generieren
npm run db:generate

# Migration ausführen
npm run db:migrate
```

### 4. Entwicklungsserver starten

```bash
npm run dev
```

## Features

- ✅ Registrierung mit E-Mail/Passwort (min. 12 Zeichen)
- ✅ Automatisches 2FA-Setup nach Registrierung
- ✅ QR-Code für Google Authenticator
- ✅ TOTP-Verifizierung (6-stelliger Code)
- ✅ Backup-Codes (10 Codes, einmalig angezeigt)
- ✅ Login mit/ohne 2FA
- ✅ Rate-Limiting (5 Versuche/5 Min)
- ✅ JWT-basierte Session-Verwaltung
- ✅ Sichere Passwort-Hashes (bcrypt, cost 12)

## API Routes

### POST /api/register
Registriert einen neuen Benutzer.

**Body:**
```json
{
  "email": "user@example.com",
  "password": "min12characters",
  "title": "Dr." // optional
}
```

**Response:**
```json
{
  "userId": "clx...",
  "tempToken": "eyJ..."
}
```

### POST /api/2fa/setup
Erstellt TOTP-Secret und QR-Code.

**Body:**
```json
{
  "tempToken": "eyJ..."
}
```

**Response:**
```json
{
  "qrDataUrl": "data:image/png;base64,...",
  "otpauthUrl": "otpauth://totp/..."
}
```

### POST /api/2fa/verify
Verifiziert TOTP-Code und aktiviert 2FA.

**Body:**
```json
{
  "token": "123456",
  "tempToken": "eyJ..."
}
```

**Response:**
```json
{
  "enabled": true,
  "backupCodes": ["ABC123...", ...] // Nur einmalig!
}
```

### POST /api/login
Anmeldung mit E-Mail/Passwort.

**Body:**
```json
{
  "email": "user@example.com",
  "password": "password"
}
```

**Response (ohne 2FA):**
```json
{
  "accessToken": "eyJ...",
  "requires2fa": false
}
```

**Response (mit 2FA):**
```json
{
  "requires2fa": true,
  "tempToken": "eyJ..."
}
```

### POST /api/login/2fa
2FA-Verifizierung beim Login.

**Body:**
```json
{
  "token": "123456", // ODER
  "backupCode": "ABC123...",
  "tempToken": "eyJ..."
}
```

**Response:**
```json
{
  "accessToken": "eyJ...",
  "requires2fa": false
}
```

### GET /api/session/me
Aktuelle Session abrufen.

**Header:**
```
Authorization: Bearer <accessToken>
```

**Response:**
```json
{
  "user": {
    "id": "clx...",
    "email": "user@example.com",
    "title": "Dr.",
    "twoFactorEnabled": true,
    "createdAt": "2024-01-01T00:00:00.000Z"
  }
}
```

## Sicherheit

- **Passwörter:** bcrypt mit cost 12
- **JWT:** HS256, 1 Tag Gültigkeit
- **TOTP:** speakeasy mit 30s Window, ±1 Window erlaubt
- **Rate-Limiting:** 5 Versuche pro 5 Minuten (in-memory)
- **Backup-Codes:** bcrypt gehasht, einmalig verwendbar
- **Secrets:** Nie in Logs ausgegeben

## Edge Cases

- **Zeitdrift:** Window von 1 erlaubt ±30 Sekunden
- **Secret neu koppeln:** Nur möglich, wenn `twoFactorEnabled=false`
- **Backup-Codes:** Werden nur beim Enable-Erfolg zurückgegeben

## Entwicklung

```bash
# Prisma Studio öffnen (Datenbank-GUI)
npm run db:studio

# Neue Migration erstellen
npx prisma migrate dev --name migration_name
```

## Produktion

- Rate-Limiting auf Redis umstellen
- JWT_SECRET sicher speichern (z.B. Vercel Secrets)
- DATABASE_URL sicher speichern
- HTTPS verwenden
- CSRF-Token optional ergänzen

