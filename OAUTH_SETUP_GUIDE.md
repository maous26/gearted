# OAuth Setup Guide for Gearted

## 📋 Overview
This guide will help you configure Google OAuth and Facebook OAuth for both web and mobile authentication in the Gearted marketplace.

## 🔧 Prerequisites
- Google Cloud Console account
- Facebook for Developers account
- Android SDK configured
- iOS development environment (for iOS builds)

## 🌐 Google OAuth Setup

### Step 1: Create Google Cloud Project
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing project
3. Enable the Google+ API and Google OAuth 2.0 API

### Step 2: Configure OAuth Consent Screen
1. Navigate to **APIs & Services** → **OAuth consent screen**
2. Choose **External** user type
3. Fill in the required information:
   - App name: `Gearted`
   - User support email: Your email
   - Authorized domains: `localhost` (for development)
   - Developer contact information: Your email

### Step 3: Create OAuth 2.0 Credentials
1. Go to **APIs & Services** → **Credentials**
2. Click **+ CREATE CREDENTIALS** → **OAuth 2.0 Client IDs**
3. Create credentials for each platform:

#### Web Application
- **Application type**: Web application
- **Name**: Gearted Web
- **Authorized JavaScript origins**: 
  - `http://localhost:3000` (development)
  - `https://yourdomain.com` (production)
- **Authorized redirect URIs**:
  - `http://localhost:3000/auth/google/callback`
  - `https://yourdomain.com/auth/google/callback`

#### Android Application
- **Application type**: Android
- **Name**: Gearted Android
- **Package name**: `com.gearted.app` (from `android/app/build.gradle`)
- **SHA-1 certificate fingerprint**: Generate using:
  ```bash
  cd android
  ./gradlew signingReport
  ```

#### iOS Application (if needed)
- **Application type**: iOS
- **Name**: Gearted iOS
- **Bundle ID**: From `ios/Runner.xcodeproj/project.pbxproj`

### Step 4: Download Configuration Files
- **Web**: Copy Client ID and Client Secret to `.env` file
- **Android**: Download `google-services.json` and place in `android/app/`
- **iOS**: Download `GoogleService-Info.plist` and add to iOS project

## 📘 Facebook OAuth Setup

### Step 1: Create Facebook App
1. Go to [Facebook for Developers](https://developers.facebook.com/)
2. Click **My Apps** → **Create App**
3. Choose **Consumer** → **Next**
4. Fill in app details:
   - App name: `Gearted`
   - App contact email: Your email

### Step 2: Configure Facebook Login
1. In your app dashboard, click **+ Add Product**
2. Find **Facebook Login** and click **Set Up**
3. Choose platforms:
   - **Web**: Add platform and set Site URL to `http://localhost:3000`
   - **Android**: Add platform with package name and key hashes
   - **iOS**: Add platform with Bundle ID

### Step 3: Configure Valid OAuth Redirect URIs
1. Go to **Facebook Login** → **Settings**
2. Add Valid OAuth Redirect URIs:
   - `http://localhost:3000/auth/facebook/callback`
   - `https://yourdomain.com/auth/facebook/callback`

### Step 4: Get App Credentials
1. Go to **Settings** → **Basic**
2. Copy **App ID** and **App Secret** to your `.env` file

## 📱 Mobile Platform Configuration

### Android Configuration

#### 1. Update build.gradle (app-level)
Add to `android/app/build.gradle`:
```gradle
dependencies {
    implementation 'com.google.android.gms:play-services-auth:20.7.0'
    implementation 'com.facebook.android:facebook-android-sdk:16.2.0'
}
```

#### 2. Update AndroidManifest.xml
Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET" />

<application>
    <!-- Google Sign In -->
    <meta-data
        android:name="com.google.android.gms.version"
        android:value="@integer/google_play_services_version" />
    
    <!-- Facebook -->
    <meta-data 
        android:name="com.facebook.sdk.ApplicationId" 
        android:value="@string/facebook_app_id"/>
    <meta-data 
        android:name="com.facebook.sdk.ClientToken" 
        android:value="@string/facebook_client_token"/>
    
    <activity 
        android:name="com.facebook.FacebookActivity"
        android:configChanges="keyboard|keyboardHidden|screenLayout|screenSize|orientation"
        android:label="@string/app_name" />
</application>
```

#### 3. Add strings.xml
Create/update `android/app/src/main/res/values/strings.xml`:
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">Gearted</string>
    <string name="facebook_app_id">YOUR_FACEBOOK_APP_ID</string>
    <string name="facebook_client_token">YOUR_FACEBOOK_CLIENT_TOKEN</string>
</resources>
```

### iOS Configuration (if building for iOS)

#### 1. Update Info.plist
Add to `ios/Runner/Info.plist`:
```xml
<key>CFBundleURLTypes</key>
<array>
    <!-- Google Sign In -->
    <dict>
        <key>CFBundleURLName</key>
        <string>REVERSED_CLIENT_ID</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>REVERSED_CLIENT_ID_FROM_GOOGLE_SERVICE_INFO</string>
        </array>
    </dict>
    <!-- Facebook -->
    <dict>
        <key>CFBundleURLName</key>
        <string>facebook</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>fbYOUR_FACEBOOK_APP_ID</string>
        </array>
    </dict>
</array>

<key>FacebookAppID</key>
<string>YOUR_FACEBOOK_APP_ID</string>
<key>FacebookClientToken</key>
<string>YOUR_FACEBOOK_CLIENT_TOKEN</string>
<key>FacebookDisplayName</key>
<string>Gearted</string>
```

## 🔐 Environment Variables

Update your `.env` files with the obtained credentials:

### Backend (.env)
```env
# Google OAuth
GOOGLE_CLIENT_ID=your_google_client_id_here
GOOGLE_CLIENT_SECRET=your_google_client_secret_here

# Facebook OAuth
FACEBOOK_APP_ID=your_facebook_app_id_here
FACEBOOK_APP_SECRET=your_facebook_app_secret_here

# Client URL (for redirects)
CLIENT_URL=http://localhost:3000
```

### Mobile (.env)
```env
GOOGLE_WEB_CLIENT_ID=your_google_web_client_id_here
FACEBOOK_APP_ID=your_facebook_app_id_here
```

## 🧪 Testing OAuth Integration

### Backend Testing
1. Start the backend server:
   ```bash
   cd gearted-backend
   npm run dev
   ```

2. Test web OAuth flows:
   - Google: `http://localhost:5000/api/auth/google`
   - Facebook: `http://localhost:5000/api/auth/facebook`

3. Test mobile OAuth endpoints:
   - Google: `POST http://localhost:5000/api/auth/google/mobile`
   - Facebook: `POST http://localhost:5000/api/auth/facebook/mobile`

### Mobile Testing
1. Start the Flutter app:
   ```bash
   cd gearted-mobile
   flutter run
   ```

2. Test OAuth buttons on login/register screens
3. Verify token storage and navigation to home screen

## 🐛 Troubleshooting

### Common Issues

#### Google Sign-In Issues
- **Error 10**: Ensure SHA-1 fingerprint is correctly configured
- **Error 12500**: Check google-services.json placement and validity
- **Web client not found**: Ensure web client ID is in google-services.json

#### Facebook Login Issues
- **Hash key mismatch**: Generate and add correct key hash to Facebook app
- **Invalid redirect URI**: Ensure redirect URIs match exactly
- **App not live**: Facebook app might need to be made public

#### Backend Issues
- **Passport strategy error**: Check environment variables are loaded
- **CORS issues**: Ensure CLIENT_URL is correctly configured
- **Session issues**: Verify session secret is set

### Debug Commands
```bash
# Check Android key hash
cd android
./gradlew signingReport

# Check SHA-1 fingerprint
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# Flutter clean build
flutter clean
flutter pub get
flutter run
```

## 🚀 Production Deployment

### Before Going Live
1. **Update OAuth redirect URIs** with production URLs
2. **Configure production environment variables**
3. **Generate production signing keys** for Android
4. **Configure App Store** credentials for iOS
5. **Make Facebook app public** (submit for review if needed)
6. **Test all OAuth flows** in production environment

### Security Checklist
- [ ] All sensitive credentials in environment variables
- [ ] Production redirect URIs configured
- [ ] SSL/HTTPS enabled in production
- [ ] Rate limiting configured for auth endpoints
- [ ] Error handling doesn't expose sensitive information
- [ ] Tokens have appropriate expiration times
- [ ] Account linking/unlinking properly implemented

---

## 📞 Support
If you encounter issues, check:
1. Google Cloud Console error logs
2. Facebook App dashboard debug tool
3. Flutter logs: `flutter logs`
4. Backend logs for authentication errors

Remember to keep your OAuth credentials secure and never commit them to version control!
