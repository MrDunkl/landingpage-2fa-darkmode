# Neuro-Via - Landing Page mit 2FA

Eine moderne Landing Page mit vollständiger 2FA-Integration (TOTP via Google Authenticator) in Next.js 14.

## 🚀 Features

- **2FA-Authentifizierung** mit TOTP (Google Authenticator)
- **Registrierung** mit vollständigem Formular
- **Login** mit automatischer 2FA-Verifizierung
- **Dunkler/Heller Modus** mit Video-Hintergründen
- **Apple-Design** mit Liquid Glass Effekten
- **PostgreSQL** Datenbank mit Prisma ORM
- **Automatische Verifizierung** - 2FA-Code wird automatisch verifiziert bei 6 Zeichen

## 📋 Voraussetzungen

- Node.js 18+ 
- PostgreSQL 14+
- npm oder yarn

## 🔧 Installation

1. **Repository klonen:**
```bash
git clone <repository-url>
cd neuro-via-github
```

2. **Dependencies installieren:**
```bash
npm install
```

3. **Umgebungsvariablen einrichten:**
Erstellen Sie eine `.env` Datei im Root-Verzeichnis:
```env
# JWT Secret (generieren Sie einen neuen mit: openssl rand -base64 32)
JWT_SECRET="ihr_jwt_secret_hier"

# PostgreSQL Datenbank-Verbindung
DATABASE_URL="postgresql://username:password@localhost:5432/database_name?schema=public"
```

4. **Datenbank-Migration:**
```bash
npx prisma generate
npx prisma migrate dev --name init_2fa
```

5. **Server starten:**
```bash
npm run dev
```

Die Anwendung läuft dann unter `http://localhost:3000`

## 📁 Projektstruktur

```
neuro-via-github/
├── app/                    # Next.js App Router
│   ├── api/                # API Routes
│   │   ├── register/       # Registrierung
│   │   ├── login/          # Login & 2FA
│   │   └── 2fa/            # 2FA Setup & Verify
│   ├── (auth)/             # Auth-Seiten
│   ├── coming-soon/        # Coming Soon Seite
│   └── registration-success/ # Erfolgsseite
├── components/             # React Komponenten
│   ├── LoginModal.tsx      # Login Modal
│   ├── RegisterModal.tsx   # Registrierung Modal
│   ├── DarkModeToggle.tsx  # Dark Mode Toggle
│   └── VideoBackground.tsx # Video Hintergrund
├── lib/                    # Utilities
│   ├── db.ts               # Prisma Client
│   ├── jwt.ts              # JWT Funktionen
│   ├── validation.ts       # Zod Schemas
│   └── api.ts              # API Client
├── prisma/                 # Prisma Schema
│   └── schema.prisma       # Datenbank Schema
└── public/                 # Statische Dateien
    ├── background-video.mp4
    └── background-dark.mp4
```

## 🔐 2FA Setup

1. **Registrieren Sie einen neuen Benutzer**
2. **Scannen Sie den QR-Code** mit Google Authenticator
3. **Geben Sie den 6-stelligen Code ein** - wird automatisch verifiziert
4. **Nach erfolgreicher Verifizierung** → Weiterleitung zur Coming Soon Seite

## 🎨 Design

- **macOS High Sierra** inspiriertes Design
- **Liquid Glass** Effekte für Modals und Buttons
- **Video-Hintergründe** für Light/Dark Mode
- **Automatische Theme-Erkennung**

## 📝 API Endpoints

- `POST /api/register` - Benutzer registrieren
- `POST /api/2fa/setup` - 2FA Setup (QR-Code generieren)
- `POST /api/2fa/verify` - 2FA Verifizierung
- `POST /api/login` - Login (gibt tempToken wenn 2FA aktiviert)
- `POST /api/login/2fa` - 2FA Login Verifizierung
- `GET /api/session/me` - Aktuelle Session

## 🛠️ Technologien

- **Next.js 14** (App Router)
- **TypeScript**
- **Prisma 5** (PostgreSQL)
- **bcrypt** (Passwort-Hashing)
- **jsonwebtoken** (JWT)
- **speakeasy** (TOTP)
- **qrcode** (QR-Code Generation)
- **zod** (Validation)
- **Tailwind CSS**
- **Framer Motion** (Animationen)
- **next-themes** (Theme Management)

## 📄 Lizenz

Dieses Projekt ist privat.

## 👤 Autor

Neuro-Via Team
