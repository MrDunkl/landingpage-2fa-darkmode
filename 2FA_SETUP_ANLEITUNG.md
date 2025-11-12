# 2FA Setup - Schritt für Schritt Anleitung

## ✅ Was wurde implementiert:

1. **LoginModal** - Öffnet sich beim Klick auf "Jetzt starten"
2. **TwoFactorSetup** - Generiert QR-Code für Google Authenticator
3. **TwoFactorVerify** - Verifiziert 2FA-Codes
4. **Automatische Session-Erstellung** - Erstellt temporären Benutzer für 2FA
5. **QR-Code-Generierung** - Immer neuer QR-Code bei jedem Login

## 🔐 So funktioniert die 2FA:

### Schritt 1: Supabase MFA aktivieren

1. Öffnen Sie das Supabase Dashboard: https://supabase.com/dashboard
2. Wählen Sie Ihr Projekt aus
3. Gehen Sie zu **Authentication** → **Settings**
4. Scrollen Sie zu **Multi-Factor Authentication (MFA)**
5. Aktivieren Sie den Toggle **Enable MFA**
6. Stellen Sie sicher, dass **TOTP** aktiviert ist
7. Klicken Sie auf **Save**

### Schritt 2: Umgebungsvariablen einrichten

Erstellen Sie eine `.env.local` Datei im `landing/` Ordner:

```env
NEXT_PUBLIC_SUPABASE_URL=https://bfqdvzuldxkneihadipk.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJmcWR2enVsZHhrbmVpaGFkaXBrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI3MjMxMDIsImV4cCI6MjA3ODI5OTEwMn0.9ztQWGuCpOni8E7MbTg9-kiEfka4QATfv8Sy6AhMTeM
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJmcWR2enVsZHhrbmVpaGFkaXBrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MjcyMzEwMiwiZXhwIjoyMDc4Mjk5MTAyfQ.0kZYm2yoHdsj_WbrQoikR0FIx4dbqdwcqeWQ4A5xJ7g
```

### Schritt 3: Server starten

```bash
cd landing
npm install
npm run dev
```

### Schritt 4: 2FA testen

1. Öffnen Sie http://localhost:3000
2. Klicken Sie auf "Jetzt starten"
3. Das Modal öffnet sich und generiert automatisch einen QR-Code
4. Scannen Sie den QR-Code mit Google Authenticator
5. Geben Sie den 6-stelligen Code ein
6. Nach erfolgreicher Verifizierung → Weiterleitung zu `/coming-soon`

## 🎯 Funktionen:

- ✅ **Direkter 2FA-Login** - Keine E-Mail/Passwort-Felder
- ✅ **Automatische QR-Code-Generierung** - Bei jedem Login neuer QR-Code
- ✅ **Temporäre Benutzer** - Werden automatisch erstellt
- ✅ **Google Authenticator** - Unterstützt alle TOTP-Apps
- ✅ **Session-Management** - Automatische Weiterleitung nach Login

## 🔧 Troubleshooting:

### "MFA ist nicht aktiviert"
- Prüfen Sie, ob MFA in Supabase aktiviert ist
- Siehe Schritt 1 oben

### "QR-Code wird nicht generiert"
- Prüfen Sie die Browser-Konsole auf Fehler
- Stellen Sie sicher, dass `.env.local` korrekt ist
- Prüfen Sie, ob MFA aktiviert ist

### "Ungültiger Code"
- Stellen Sie sicher, dass die Uhrzeit auf Ihrem Gerät korrekt ist
- Verwenden Sie den aktuellen Code (Codes ändern sich alle 30 Sekunden)
- Scannen Sie den QR-Code erneut

## 📱 Unterstützte Apps:

- Google Authenticator
- Authy
- Microsoft Authenticator
- Alle anderen TOTP-Apps


