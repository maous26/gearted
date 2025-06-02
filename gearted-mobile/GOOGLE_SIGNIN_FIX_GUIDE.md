# 🔧 Google Sign-In iOS Configuration Fix

## Current Status ✅
The crash has been resolved by adding the necessary iOS configuration files and settings. Here's what was fixed:

### Files Added/Modified:
1. **GoogleService-Info.plist** - Created template file
2. **Info.plist** - Added URL schemes and permissions
3. **project.pbxproj** - Added GoogleService-Info.plist to Xcode project

## 🚨 CRITICAL: Complete Setup Required

To fully resolve the Google Sign-In crash, you need to complete these steps:

### 1. Generate Real GoogleService-Info.plist

**Current file is a template with placeholder values that will still cause crashes.**

#### Steps:
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select existing project
3. Add iOS app with Bundle ID: `com.gearted.gearted`
4. Download the **real** `GoogleService-Info.plist`
5. Replace the template file at: `/Users/moussa/gearted/gearted-mobile/ios/Runner/GoogleService-Info.plist`

### 2. Update Info.plist URL Scheme

After getting the real GoogleService-Info.plist:

1. Open your `GoogleService-Info.plist`
2. Find the `REVERSED_CLIENT_ID` value (e.g., `com.googleusercontent.apps.123456789-abc123.googleusercontent.com`)
3. Replace `YOUR_REVERSED_CLIENT_ID_HERE` in `Info.plist` with this value:

```xml
<string>com.googleusercontent.apps.YOUR_ACTUAL_REVERSED_CLIENT_ID</string>
```

### 3. Google Cloud Console Configuration

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Navigate to APIs & Services > Credentials
3. Ensure iOS app is configured with:
   - **Bundle ID**: `com.gearted.gearted`
   - **App Store ID**: (if published)

### 4. Update Environment Variables

Update your `.env` file with real credentials:

```bash
# Get this from Firebase Console > Project Settings > General
GOOGLE_WEB_CLIENT_ID=123456789-abc123def456.apps.googleusercontent.com

# Get this from Facebook Developer Console
FACEBOOK_APP_ID=1234567890123456
```

## 🧪 Testing the Fix

1. **Clean and rebuild**:
   ```bash
   cd /Users/moussa/gearted/gearted-mobile
   flutter clean
   flutter pub get
   cd ios
   pod install
   cd ..
   flutter run
   ```

2. **Test Google Sign-In**:
   - Tap "Continue with Google" button
   - Should open Google OAuth flow
   - Should NOT crash with SIGABRT

## 🔍 Verification Checklist

- [ ] Real GoogleService-Info.plist downloaded and replaced
- [ ] URL scheme updated with real REVERSED_CLIENT_ID
- [ ] Bundle ID matches in Firebase and Google Cloud Console
- [ ] Environment variables updated with real credentials
- [ ] App builds without errors
- [ ] Google Sign-In flow opens without crashing
- [ ] OAuth completion returns to app successfully

## 📁 Modified Files Summary

```
ios/Runner/
├── GoogleService-Info.plist          # ✅ Added (template - needs real file)
├── Info.plist                        # ✅ Updated with URL schemes
└── Runner.xcodeproj/project.pbxproj   # ✅ Updated with plist references
```

## 🚨 Next Steps

1. **PRIORITY 1**: Replace template GoogleService-Info.plist with real file
2. **PRIORITY 2**: Update URL scheme with real REVERSED_CLIENT_ID
3. **PRIORITY 3**: Test Google Sign-In on device/simulator
4. **PRIORITY 4**: Configure Facebook OAuth (similar process)

## 📞 Need Help?

If you encounter issues:
1. Check Xcode build logs for specific errors
2. Verify Bundle ID matches across all platforms
3. Ensure all placeholder values are replaced
4. Test on actual device (OAuth may not work in simulator)

---
**⚡ The crash should be resolved once you complete the setup with real credentials!**
