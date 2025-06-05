// test-admin-console-login.js
const axios = require('axios');

const API_BASE_URL = 'http://localhost:3000/api';
const email = 'admin@gearted.com';
const password = 'admin123';

async function testAdminLogin() {
  try {
    console.log(`Testing admin login flow for ${email}...`);
    
    // Step 1: Try login
    console.log('\n1. Authenticating with credentials...');
    const authResponse = await axios.post(`${API_BASE_URL}/auth/login`, { 
      email, 
      password 
    });
    
    console.log('Authentication response:');
    console.log(`Status: ${authResponse.status}`);
    console.log(`User: ${authResponse.data.user.email}`);
    console.log(`Token received: ${authResponse.data.token.substring(0, 20)}...`);
    
    const token = authResponse.data.token;
    
    // Step 2: Verify admin access with the token
    console.log('\n2. Verifying admin access...');
    try {
      const adminResponse = await axios.get(`${API_BASE_URL}/admin/stats`, {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      });
      
      console.log('Admin access response:');
      console.log(`Status: ${adminResponse.status}`);
      console.log(`Users: ${adminResponse.data.users}`);
      console.log(`Listings: ${adminResponse.data.listings}`);
      console.log(`Messages: ${adminResponse.data.messages}`);
      
      console.log('\n✅ SUCCESS: Admin login flow works correctly!');
    } catch (adminError) {
      console.error('\n❌ ERROR: Admin access verification failed');
      console.error(`Status: ${adminError.response?.status}`);
      console.error(`Message: ${adminError.response?.data?.message || adminError.message}`);
    }
    
  } catch (error) {
    console.error('\n❌ ERROR: Authentication failed');
    console.error(`Status: ${error.response?.status}`);
    console.error(`Message: ${error.response?.data?.message || error.message}`);
  }
}

testAdminLogin();
