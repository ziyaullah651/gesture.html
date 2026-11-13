# JanSamadhan — first working MVP scaffold

This is a Flutter starter project for Android and iOS. It includes:
- Citizen home dashboard
- Issue category tiles
- Report form with validation
- Local demo complaint creation
- My reports / status tracking screen
- Representative directory placeholder
- Supabase PostgreSQL starter schema

## Important status
This is a **runnable UI prototype**, not yet a production complaint service. Reports currently stay in app memory. Photo/video upload, GPS, OTP authentication, live database sync, representative routing, push notifications and the admin portal are the next implementation steps.

## Run the app
1. Install Flutter SDK and Android Studio / Xcode.
2. Unzip this project.
3. From the project directory run:
   ```bash
   flutter pub get
   flutter run
   ```
4. For iOS, run on macOS with Xcode installed.

## Connect Supabase
1. Create a Supabase project.
2. Open SQL Editor and run `supabase/schema.sql`.
3. Run:
   ```bash
   flutter run --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co --dart-define=SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
   ```
4. Never put the Supabase `service_role` key in the mobile app.

## Product rules before public launch
- Verify representative identity and constituency using official records and a documented review process.
- Route complaints by verified geography and issue jurisdiction; never promise that a politician personally receives or resolves every complaint.
- Provide reporting, moderation, duplicate detection, appeals and abuse controls.
- Minimize personal data; hide citizens' phone numbers and private details from public views.
- Publish privacy policy, terms, retention policy and grievance contact.
- Add server-side authorization and audit logs before production.

## Suggested next build
Implement Supabase Auth + profile onboarding, photo upload to private storage, GPS capture, and live complaint creation with server-side reference codes.
