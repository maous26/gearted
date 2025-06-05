const axios = require('axios');

const BASE_URL = 'http://localhost:3000/api';

// Test OAuth notifications
async function testOAuthNotifications() {
  console.log('🧪 Testing OAuth Notification Service...\n');

  try {
    // First, create a test user via email registration
    console.log('1. Creating test user...');
    const registerResponse = await axios.post(`${BASE_URL}/auth/register`, {
      username: 'oauthTestUser',
      email: 'oauth.test@gearted.com',
      password: 'testpass123'
    });

    if (registerResponse.status === 201) {
      console.log('✅ Test user created successfully');
      const userId = registerResponse.data.user.id;

      // Test different OAuth notification types
      const notifications = [
        { type: 'login_success', provider: 'google', description: 'OAuth Login Success' },
        { type: 'account_linked', provider: 'google', description: 'Account Linked' },
        { type: 'welcome', provider: 'facebook', description: 'OAuth Welcome' },
        { type: 'email_verified', provider: 'google', description: 'Email Verified' },
        { type: 'security_alert', provider: 'facebook', description: 'Security Alert' }
      ];

      console.log('\n2. Testing OAuth notifications...');
      for (const notification of notifications) {
        try {
          const response = await axios.post(`${BASE_URL}/auth/test-oauth-notifications`, {
            userId,
            notificationType: notification.type,
            provider: notification.provider
          });

          if (response.status === 200) {
            console.log(`✅ ${notification.description} (${notification.provider}): ${response.data.message}`);
          }
        } catch (error) {
          console.log(`❌ ${notification.description}: ${error.response?.data?.message || error.message}`);
        }
        
        // Small delay between notifications
        await new Promise(resolve => setTimeout(resolve, 500));
      }

      console.log('\n3. Testing FCM token management...');
      
      // Test FCM token update (requires authentication)
      const loginResponse = await axios.post(`${BASE_URL}/auth/login`, {
        email: 'oauth.test@gearted.com',
        password: 'testpass123'
      });

      if (loginResponse.status === 200) {
        const token = loginResponse.data.token;
        
        // Update FCM token
        try {
          const fcmResponse = await axios.put(`${BASE_URL}/auth/fcm-token`, {
            fcmToken: 'test_fcm_token_123456'
          }, {
            headers: { Authorization: `Bearer ${token}` }
          });
          
          if (fcmResponse.status === 200) {
            console.log('✅ FCM token updated successfully');
          }
        } catch (error) {
          console.log(`❌ FCM token update failed: ${error.response?.data?.message || error.message}`);
        }

        // Remove FCM token
        try {
          const fcmRemoveResponse = await axios.delete(`${BASE_URL}/auth/fcm-token`, {
            headers: { Authorization: `Bearer ${token}` }
          });
          
          if (fcmRemoveResponse.status === 200) {
            console.log('✅ FCM token removed successfully');
          }
        } catch (error) {
          console.log(`❌ FCM token removal failed: ${error.response?.data?.message || error.message}`);
        }
      }

    }

    console.log('\n4. Testing mobile OAuth flows...');
    
    // Test mobile Google auth
    try {
      const mobileGoogleResponse = await axios.post(`${BASE_URL}/auth/google/mobile`, {
        idToken: 'test_google_id_token',
        email: 'mobile.google@gearted.com',
        displayName: 'Mobile Google User',
        photoUrl: 'https://example.com/photo.jpg'
      });

      if (mobileGoogleResponse.status === 200) {
        console.log('✅ Mobile Google OAuth: User authenticated with notifications');
      }
    } catch (error) {
      console.log(`❌ Mobile Google OAuth: ${error.response?.data?.message || error.message}`);
    }

    // Test mobile Facebook auth
    try {
      const mobileFacebookResponse = await axios.post(`${BASE_URL}/auth/facebook/mobile`, {
        accessToken: 'test_facebook_access_token',
        email: 'mobile.facebook@gearted.com',
        name: 'Mobile Facebook User',
        picture: 'https://example.com/fb-photo.jpg'
      });

      if (mobileFacebookResponse.status === 200) {
        console.log('✅ Mobile Facebook OAuth: User authenticated with notifications');
      }
    } catch (error) {
      console.log(`❌ Mobile Facebook OAuth: ${error.response?.data?.message || error.message}`);
    }

  } catch (error) {
    console.error('❌ Test setup failed:', error.response?.data?.message || error.message);
  }

  console.log('\n🎉 OAuth Notification Service testing completed!');
}

// Run the test
testOAuthNotifications().catch(console.error);
