# Supabase Konfiguration für 2FA

## Wichtige Einstellungen

### 1. E-Mail-Bestätigung deaktivieren (für temporäre Benutzer)

Damit temporäre Benutzer ohne E-Mail-Bestätigung erstellt werden können:

1. Öffnen Sie das Supabase Dashboard: https://supabase.com/dashboard
2. Wählen Sie Ihr Projekt aus
3. Gehen Sie zu **Authentication** → **Settings**
4. Scrollen Sie zu **Email Auth**
5. Deaktivieren Sie **"Confirm email"** (E-Mail-Bestätigung)
6. Klicken Sie auf **Save**

**Wichtig**: Wenn E-Mail-Bestätigung aktiviert ist, wird keine Session zurückgegeben und die 2FA-Anmeldung funktioniert nicht.

### 2. MFA aktivieren

1. Gehen Sie zu **Authentication** → **Settings**
2. Scrollen Sie zu **Multi-Factor Authentication (MFA)**
3. Aktivieren Sie den Toggle **Enable MFA**
4. Stellen Sie sicher, dass **TOTP** aktiviert ist
5. Klicken Sie auf **Save**

### 3. E-Mail-Domain-Validierung

Supabase validiert E-Mail-Adressen. Die App verwendet `@example.com` für temporäre Benutzer.

Falls `example.com` blockiert wird, können Sie:

**Option A**: Eine eigene Domain verwenden
- Erstellen Sie eine E-Mail-Domain in Supabase
- Oder verwenden Sie eine echte Domain, die Sie kontrollieren

**Option B**: E-Mail-Validierung anpassen
- In Supabase können Sie die E-Mail-Validierung anpassen
- Gehen Sie zu **Authentication** → **Settings** → **Email Auth**
- Überprüfen Sie die E-Mail-Validierungsregeln

### 4. Umgebungsvariablen

Stellen Sie sicher, dass Ihre `.env.local` Datei korrekt konfiguriert ist:

```env
NEXT_PUBLIC_SUPABASE_URL=https://bfqdvzuldxkneihadipk.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

## Fehlerbehebung

### "E-Mail-Bestätigung ist aktiviert"
- Deaktivieren Sie E-Mail-Bestätigung in Supabase (siehe Schritt 1)
- Oder verwenden Sie Magic Links für die Anmeldung

### "Email address is invalid"
- Stellen Sie sicher, dass die verwendete E-Mail-Domain gültig ist
- `example.com` sollte funktionieren, aber manche Supabase-Instanzen blockieren es
- Verwenden Sie eine echte Domain oder passen Sie die Validierung an

### "Auth session missing"
- Stellen Sie sicher, dass E-Mail-Bestätigung deaktiviert ist
- Überprüfen Sie, ob die Supabase-URL und der Anon-Key korrekt sind
- Prüfen Sie die Browser-Konsole auf weitere Fehler

### "MFA ist nicht aktiviert"
- Aktivieren Sie MFA in Supabase (siehe Schritt 2)
- Stellen Sie sicher, dass TOTP aktiviert ist

## Video-Hintergrund

Das Video-Hintergrund-Feature ist optional. Falls die Video-Datei nicht vorhanden ist, wird automatisch ein Fallback-Hintergrund angezeigt.

Platzieren Sie Ihre Video-Datei hier:
```
landing/public/background-video.mp4
```

Die App funktioniert auch ohne Video-Datei.

