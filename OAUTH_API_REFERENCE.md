# 🔗 OAuth API Reference - Quick Guide

## 📱 **Mobile OAuth Endpoints**

### **Google OAuth (Mobile)**
```typescript
POST /api/auth/google/mobile
Content-Type: application/json

{
  "idToken": "google_id_token_from_mobile_sdk",
  "email": "user@example.com", 
  "displayName": "User Name",
  "photoUrl": "https://profile-photo-url"
}

// Response
{
  "success": true,
  "token": "jwt_token_here",
  "user": {
    "id": "user_id",
    "username": "username", 
    "email": "user@example.com",
    "profileImage": "profile_url",
    "provider": "google"
  }
}
```

### **Facebook OAuth (Mobile)**
```typescript
POST /api/auth/facebook/mobile
Content-Type: application/json

{
  "accessToken": "facebook_access_token_from_mobile_sdk",
  "email": "user@example.com",
  "name": "User Name", 
  "picture": "https://profile-photo-url"
}

// Response (same as Google)
{
  "success": true,
  "token": "jwt_token_here",
  "user": { /* user object */ }
}
```

## 🌐 **Web OAuth Endpoints**

### **Google OAuth (Web)**
```typescript
// Step 1: Redirect to Google
GET /api/auth/google
// Redirects to Google OAuth consent screen

// Step 2: Handle callback
GET /api/auth/google/callback?code=auth_code&state=state
// Redirects to CLIENT_URL with token or error
```

### **Facebook OAuth (Web)**
```typescript
// Step 1: Redirect to Facebook  
GET /api/auth/facebook
// Redirects to Facebook OAuth consent screen

// Step 2: Handle callback
GET /api/auth/facebook/callback?code=auth_code&state=state
// Redirects to CLIENT_URL with token or error
```

## 📧 **Traditional Authentication**

### **Email Registration**
```typescript
POST /api/auth/register
Content-Type: application/json

{
  "username": "username",
  "email": "user@example.com",
  "password": "password123"
}
```

### **Email Login**
```typescript
POST /api/auth/login
Content-Type: application/json

{
  "email": "user@example.com", 
  "password": "password123"
}
```

## 🔔 **Push Notification Management**

### **Update FCM Token**
```typescript
PUT /api/auth/fcm-token
Authorization: Bearer jwt_token
Content-Type: application/json

{
  "fcmToken": "firebase_fcm_token_here"
}
```

### **Remove FCM Token**
```typescript
DELETE /api/auth/fcm-token
Authorization: Bearer jwt_token
```

## 🧪 **Testing Endpoints** 

### **Test OAuth Notifications** (Development Only)
```typescript
POST /api/auth/test-oauth-notifications
Content-Type: application/json

{
  "userId": "user_object_id",
  "notificationType": "login_success|account_linked|welcome|email_verified|security_alert",
  "provider": "google|facebook"
}
```

### **Get Current User**
```typescript
GET /api/auth/me
Authorization: Bearer jwt_token

// Response
{
  "success": true,
  "user": {
    "id": "user_id",
    "username": "username",
    "email": "user@example.com", 
    "provider": "local|google|facebook",
    "isEmailVerified": true,
    "connectedProviders": ["email", "google"]
  }
}
```

## 📱 **Flutter Mobile Integration**

### **AuthService Usage**
```dart
// Google Sign-In
final result = await AuthService().signInWithGoogle();

// Facebook Sign-In  
final result = await AuthService().signInWithFacebook();

// Email Registration
await AuthService().signUpWithEmail(username, email, password);

// Email Login
await AuthService().signInWithEmail(email, password);

// Logout
await AuthService().signOut();

// Get Current User
final user = await AuthService().getCurrentUser();
```

### **OAuth Button Implementation**
```dart
// Login Screen
_buildSocialButton(
  onPressed: () async {
    try {
      final result = await _authService.signInWithGoogle();
      if (result != null && context.mounted) {
        context.go('/home');
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google login failed: $e'))
      );
    }
  },
  icon: Icons.g_mobiledata,
)
```

## 🔔 **Notification Types**

### **OAuth Notification Coverage**
1. **`OAUTH_LOGIN_SUCCESS`** - User successfully logged in with OAuth
2. **`OAUTH_ACCOUNT_LINKED`** - OAuth provider linked to existing account
3. **`ACCOUNT_MERGE_REQUIRED`** - Email conflict detected, merge needed
4. **`NEW_OAUTH_PROVIDER_ADDED`** - New OAuth provider added to account
5. **`ACCOUNT_VERIFIED`** - Email automatically verified via OAuth
6. **`SECURITY_ALERT`** - OAuth security notifications
7. **`WELCOME`** - Welcome message for new OAuth users

### **Notification Channels**
- 📱 **Push Notifications** (FCM)
- 📧 **Email Notifications** (SMTP)
- 🔔 **In-App Notifications** (Database)

## ⚙️ **Environment Variables**

### **Backend (.env)**
```bash
# OAuth Configuration
GOOGLE_CLIENT_ID=your_google_client_id.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=your_google_client_secret
FACEBOOK_APP_ID=your_facebook_app_id
FACEBOOK_APP_SECRET=your_facebook_app_secret
CLIENT_URL=http://localhost:3000

# JWT
JWT_SECRET=your_jwt_secret
JWT_EXPIRATION=86400

# Database
DB_URI=mongodb://connection_string

# Firebase (for push notifications)
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_CLIENT_EMAIL=firebase-adminsdk@project.iam.gserviceaccount.com
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nkey_here\n-----END PRIVATE KEY-----"
```

### **Mobile (.env)**
```bash
# API
API_URL=http://localhost:3000/api

# OAuth
GOOGLE_WEB_CLIENT_ID=your_google_web_client_id.apps.googleusercontent.com
FACEBOOK_APP_ID=your_facebook_app_id
```

## 🚨 **Error Handling**

### **Common OAuth Errors**
- **`oauth_failed`** - OAuth authentication failed
- **`invalid_token`** - Invalid or expired OAuth token
- **`email_exists`** - Email already registered with different provider
- **`missing_credentials`** - OAuth app not configured
- **`network_error`** - Network connection issues

### **Error Response Format**
```typescript
{
  "success": false,
  "message": "User-friendly error message",
  "code": "ERROR_CODE", // Optional
  "details": { /* error details */ } // Optional
}
```

## 🔐 **Security Features**

### **JWT Token Format**
```typescript
// Header
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

// Payload
{
  "id": "user_object_id",
  "iat": 1633024800,
  "exp": 1633111200
}
```

### **OAuth Security**
- ✅ State parameter validation
- ✅ HTTPS-only in production
- ✅ Secure session cookies
- ✅ JWT token expiration
- ✅ Rate limiting on OAuth endpoints
- ✅ Device tracking for security alerts

---

**🎯 This API is production-ready and supports seamless OAuth authentication for your Gearted marketplace!**
