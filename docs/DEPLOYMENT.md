# MIT License - Copyright (c) 2026 InfraGuard AI Contributors

# InfraGuard AI – Deployment Guide

## 📱 Mobile App (Flutter)

### Android (Play Store)

1. **Build release APK/AAB**
   ```bash
   cd mobile
   flutter build appbundle --release
   ```

2. **Create keystore** (one-time)
   ```bash
   keytool -genkey -v -keystore ~/infraguard-upload.jks \
     -keyalg RSA -keysize 2048 -validity 10000 \
     -alias infraguard
   ```

3. **Configure signing** in `android/app/build.gradle`:
   ```groovy
   signingConfigs {
       release {
           keyAlias 'infraguard'
           keyPassword '<password>'
           storeFile file('~/infraguard-upload.jks')
           storePassword '<password>'
       }
   }
   ```

4. **Submit to Google Play Console**
   - Create app listing: "InfraGuard AI – Ghana Infrastructure Intelligence"
   - Category: Tools → Utilities
   - Upload AAB from `build/app/outputs/bundle/release/`
   - Set pricing: FREE
   - Target: Ghana (GH)

### iOS (App Store)

1. **Prerequisites**: Xcode 15+, Apple Developer account ($99/year)

2. **Build**
   ```bash
   cd mobile
   flutter build ios --release
   ```

3. **Configure in Xcode**
   - Open `ios/Runner.xcworkspace`
   - Set Bundle Identifier: `com.infraguard.ai`
   - Configure signing with your Apple Developer team
   - Set deployment target: iOS 15.0+

4. **Archive & Upload**
   - Product → Archive in Xcode
   - Upload to App Store Connect
   - Submit for review

---

## 🌐 Web Dashboard (Vercel)

### Option A: Vercel CLI

```bash
cd web
npm install
npm run build       # Verify build succeeds

# Install Vercel CLI
npm i -g vercel

# Deploy
vercel              # Follow prompts
vercel --prod       # Deploy to production
```

### Option B: GitHub Integration

1. Push `web/` to a GitHub repository
2. Go to [vercel.com](https://vercel.com) → Import Project
3. Select the repository, set root directory to `web/`
4. Add environment variables:
   ```
   NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
   NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
   ```
5. Deploy automatically on every push to `main`

### Custom Domain
```
infraguard.gh      → Vercel production
dashboard.infraguard.gh → Vercel production
```

---

## ☁️ Supabase Backend

1. **Create project** at [supabase.com](https://supabase.com)
   - Organization: InfraGuard AI
   - Region: Choose closest (EU West or Africa)
   - Plan: Free tier (sufficient for MVP)

2. **Run schema**
   - Go to SQL Editor → New query
   - Paste contents of `backend/supabase/schema.sql`
   - Execute

3. **Seed data**
   - Run `backend/supabase/seed.sql`

4. **Configure Auth**
   - Enable Email/Password
   - Enable Phone (for +233 Ghana numbers)
   - Enable Google OAuth
   - Set site URL: `https://infraguard.gh`

5. **Copy credentials** to:
   - `mobile/lib/core/constants/env.dart`
   - `web/.env.local`

---

## 🔑 API Keys Required

| Service | Purpose | Get it at |
|---------|---------|-----------|
| Supabase | Backend | supabase.com |
| Google Maps | Flutter maps | console.cloud.google.com |
| Mapbox | Offline tiles | mapbox.com |
| OpenWeatherMap | Weather data | openweathermap.org |
| Firebase | Push notifications | console.firebase.google.com |
| Hugging Face | Cloud AI inference | huggingface.co |

All services have free tiers sufficient for launch.

---

## 📊 Monitoring

- **Supabase Dashboard**: Monitor DB, auth, and storage usage
- **Vercel Analytics**: Web dashboard performance
- **Firebase Crashlytics**: Mobile app crash reports
- **Custom**: Build monitoring into the Analytics screen
