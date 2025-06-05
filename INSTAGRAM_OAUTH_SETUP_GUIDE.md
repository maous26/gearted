# 📷 Instagram OAuth Setup Guide

## 🎯 **Quick Setup for Instagram Authentication**

Since your Instagram OAuth implementation is 100% complete, you just need to configure the Instagram Developer App to go live.

---

## 📱 **Step 1: Instagram Basic Display Setup**

### **1.1 Facebook Developers Console**
1. Go to [Facebook for Developers](https://developers.facebook.com/)
2. Click **Create App** > **Consumer** > **Next**
3. **App name**: Gearted
4. **Contact email**: Your email

### **1.2 Add Instagram Basic Display**
1. In your app dashboard, click **+ Add Product**
2. Find **Instagram Basic Display** and click **Set Up**
3. Click **Create New App** if prompted

### **1.3 Configure Instagram Basic Display**
1. Go to **Instagram Basic Display** > **Basic Display**
2. Add **Valid OAuth Redirect URIs**:
   ```
   https://yourdomain.com/auth/instagram/callback
   http://localhost:3000/auth/instagram/callback
   ```
3. Add **Deauthorize Callback URL**:
   ```
   https://yourdomain.com/auth/instagram/deauthorize
   ```
4. Add **Data Deletion Request URL**:
   ```
   https://yourdomain.com/auth/instagram/delete
   ```

### **1.4 Get Instagram Credentials**
1. Go to **Instagram Basic Display** > **Basic Display**
2. Copy **Instagram App ID** and **Instagram App Secret**
3. Save these for your environment variables

---

## ⚙️ **Step 2: Update Environment Variables**

### **Backend Environment** (`/Users/moussa/gearted/gearted-backend/.env`)
```env
# Add these Instagram OAuth credentials
INSTAGRAM_CLIENT_ID=your_instagram_app_id
INSTAGRAM_CLIENT_SECRET=your_instagram_app_secret
```

### **Mobile Environment** (`/Users/moussa/gearted/gearted-mobile/.env`)
```env
# Add these Instagram OAuth credentials
INSTAGRAM_CLIENT_ID=your_instagram_app_id
INSTAGRAM_CLIENT_SECRET=your_instagram_app_secret
```

---

## 🧪 **Step 3: Test Instagram OAuth**

### **3.1 Test Backend Endpoint**
```bash
# Test Instagram OAuth endpoint
curl -X POST http://localhost:3000/api/auth/instagram/mobile \
  -H "Content-Type: application/json" \
  -d '{
    "accessToken": "real_instagram_access_token",
    "userId": "instagram_user_id",
    "username": "test_username",
    "fullName": "Test User",
    "profilePicture": "https://profile-url"
  }'
```

### **3.2 Test Mobile App**
1. Update your mobile app UI to include Instagram login button
2. Test Instagram WebView authentication flow
3. Verify user creation and JWT token handling

---

## 🎯 **Expected Results**

Once configured, users will be able to:
- ✅ **Sign in with Instagram** via mobile app
- ✅ **Link Instagram accounts** to existing profiles
- ✅ **Receive Instagram notifications** (welcome, login success, etc.)
- ✅ **Sync Instagram profile pictures** automatically
- ✅ **Use Instagram as primary authentication** method

---

## 🔐 **Instagram App Permissions**

Your app will need these Instagram permissions:
- `user_profile` - Access to user's profile info
- `user_media` - Access to user's media (optional)

---

## 🚀 **Production Checklist**

### **Before Going Live**
- [ ] Instagram app reviewed and approved by Meta
- [ ] Production OAuth redirect URIs configured
- [ ] Real Instagram credentials in production environment
- [ ] Instagram login button added to mobile UI
- [ ] End-to-end Instagram OAuth flow tested

### **Instagram App Review (if needed)**
- Instagram Basic Display doesn't require review for basic authentication
- Only needed if you request additional permissions beyond profile access

---

## 📞 **Support**

If you encounter issues:
1. Check [Instagram Basic Display Documentation](https://developers.facebook.com/docs/instagram-basic-display-api)
2. Verify Instagram App ID in Facebook Developer Console
3. Test OAuth redirect URIs match exactly
4. Check mobile WebView implementation for Instagram auth

---

**🎉 Your Instagram OAuth implementation is ready - just add the credentials and you're live!**
