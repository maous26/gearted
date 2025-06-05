// test-admin-login-detailed.js
const axios = require('axios');

const API_BASE_URL = 'http://localhost:3000/api';
const email = 'admin@gearted.com';
const password = 'admin123';

// Helper to clear localStorage in Node.js environment
const mockLocalStorage = {
  store: {},
  getItem(key) {
    return this.store[key] || null;
  },
  setItem(key, value) {
    this.store[key] = value.toString();
  },
  removeItem(key) {
    delete this.store[key];
  }
};

// Simulate the exact flow from gearted-admin/src/lib/api.ts
async function testAdminLogin() {
  console.log(`🔍 DETAILED TEST: Admin Console Login Flow Simulation`);
  console.log(`📝 Testing credentials: ${email} / ${password}`);

  try {
    // Step 1: Clear any existing tokens
    mockLocalStorage.removeItem('adminToken');
    mockLocalStorage.removeItem('adminUser');
    console.log(`\n1. ✅ Cleared previous authentication data`);

    // Step 2: Call the login endpoint
    console.log(`\n2. 🔄 Making login request to ${API_BASE_URL}/auth/login...`);
    const loginResponse = await axios.post(`${API_BASE_URL}/auth/login`, { 
      email, 
      password 
    });

    if (!loginResponse.data.success) {
      throw new Error('Authentication failed: ' + (loginResponse.data.message || 'Unknown error'));
    }

    console.log(`   ✅ Login successful`);
    console.log(`   📋 Response details:`);
    console.log(`     - Status: ${loginResponse.status}`);
    console.log(`     - User email: ${loginResponse.data.user.email}`);
    console.log(`     - Token received: ${loginResponse.data.token.substring(0, 15)}...`);

    // Step 3: Store the token in localStorage (simulated)
    mockLocalStorage.setItem('adminToken', loginResponse.data.token);
    console.log(`\n3. ✅ Stored token in localStorage`);

    // Step 4: Verify admin access with stored token
    console.log(`\n4. 🔄 Verifying admin access by calling /admin/stats...`);
    try {
      const adminResponse = await axios.get(`${API_BASE_URL}/admin/stats`, {
        headers: {
          'Authorization': `Bearer ${mockLocalStorage.getItem('adminToken')}`
        }
      });
      
      console.log(`   ✅ Admin access verified successfully`);
      console.log(`   📋 Admin stats:`);
      console.log(`     - Users: ${adminResponse.data.users}`);
      console.log(`     - Listings: ${adminResponse.data.listings}`);
      console.log(`     - Messages: ${adminResponse.data.messages}`);
      
      // Step 5: Store user data (simulated)
      mockLocalStorage.setItem('adminUser', JSON.stringify(loginResponse.data.user));
      console.log(`\n5. ✅ Stored user data in localStorage`);
      
      // Step 6: Check isAuthenticated function
      const isAuthenticated = !!mockLocalStorage.getItem('adminToken');
      console.log(`\n6. 🔍 Testing isAuthenticated(): ${isAuthenticated ? '✅ TRUE' : '❌ FALSE'}`);
      
      // Step 7: Check getCurrentUser function
      const currentUser = JSON.parse(mockLocalStorage.getItem('adminUser'));
      console.log(`\n7. 🔍 Testing getCurrentUser(): ${currentUser ? '✅ VALID USER' : '❌ NULL'}`);
      console.log(`     User: ${currentUser.email} (ID: ${currentUser.id})`);
      
      console.log(`\n✅✅✅ COMPLETE LOGIN FLOW SUCCESS`);
      console.log(`🚀 Admin user would now be redirected to dashboard`);
      
    } catch (adminError) {
      console.error(`\n❌ STEP 4 ERROR: Admin access verification failed`);
      console.error(`   Status: ${adminError.response?.status || 'Unknown'}`);
      console.error(`   Message: ${adminError.response?.data?.message || adminError.message}`);
      throw adminError; // Re-throw to skip remaining steps
    }
    
  } catch (error) {
    console.error(`\n❌❌❌ LOGIN FLOW FAILED`);
    if (error.response) {
      console.error(`   Status: ${error.response.status}`);
      console.error(`   Response data: ${JSON.stringify(error.response.data, null, 2)}`);
    } else if (error.request) {
      console.error(`   No response received. Check if server is running.`);
    } else {
      console.error(`   Error message: ${error.message}`);
    }
  }
}

testAdminLogin();
