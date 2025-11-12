# GitHub Upload Anleitung

## 📤 Projekt auf GitHub hochladen

### Schritt 1: GitHub Repository erstellen

1. Gehen Sie zu https://github.com/new
2. Erstellen Sie ein neues Repository (z.B. `neuro-via`)
3. **WICHTIG:** Wählen Sie **NICHT** "Initialize with README" (wir haben bereits ein README)

### Schritt 2: Repository initialisieren

```bash
cd /Users/leonmiguelconnerdunkl/Documents/Neuro-via/neuro-via-github

# Git initialisieren
git init

# Alle Dateien hinzufügen
git add .

# Ersten Commit erstellen
git commit -m "Initial commit: Neuro-Via Landing Page mit 2FA"

# Remote Repository hinzufügen (ersetzen Sie <username> und <repo-name>)
git remote add origin https://github.com/<username>/<repo-name>.git

# Branch auf main setzen
git branch -M main

# Code hochladen
git push -u origin main
```

### Schritt 3: .env Datei erstellen

Nach dem Klonen müssen Sie eine `.env` Datei erstellen:

```bash
cp .env.example .env
```

Dann bearbeiten Sie `.env` und setzen:
- `JWT_SECRET` - Generieren Sie einen neuen mit: `openssl rand -base64 32`
- `DATABASE_URL` - Ihre PostgreSQL Verbindungszeichenfolge

## ⚠️ Wichtige Hinweise

- ✅ **MP4-Videos sind enthalten** (background-video.mp4, background-dark.mp4)
- ❌ **.mov Dateien wurden entfernt** (zu groß für GitHub)
- ❌ **.env Dateien sind ausgeschlossen** (sicherheitsrelevant)
- ❌ **node_modules ist ausgeschlossen** (wird mit `npm install` installiert)

## 📦 Dateigröße

- **Projekt-Größe:** ~7MB (ohne node_modules)
- **MP4-Videos:** ~7MB gesamt
- **Nach `npm install`:** ~600MB (wird nicht hochgeladen)

## 🔐 Sicherheit

- **Niemals** `.env` Dateien committen
- **Niemals** Passwörter oder Secrets in den Code schreiben
- Verwenden Sie GitHub Secrets für CI/CD

## 📝 Nächste Schritte

Nach dem Upload:

1. Repository klonen: `git clone <repository-url>`
2. Dependencies installieren: `npm install`
3. `.env` Datei erstellen: `cp .env.example .env`
4. Datenbank-Migration: `npx prisma migrate dev`
5. Server starten: `npm run dev`
