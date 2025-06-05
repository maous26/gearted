// test-admin-login-simplified.js
const axios = require('axios');

const API_BASE_URL = 'http://localhost:3000/api';
const email = 'admin@gearted.com';
const password = 'admin123';

async function testAdminLogin() {
  console.log(`Testing admin login with: ${email} / ${password}`);
  
  try {
    // Step 1: Login
    console.log('\n1. Attempting login...');
    const loginResponse = await axios.post(`${API_BASE_URL}/auth/login`, { 
      email, 
      password 
    });
    
    console.log('✅ Login successful');
    console.log(`Status: ${loginResponse.status}`);
    console.log(`Token: ${loginResponse.data.token?.substring(0, 15)}...`);
    
    const token = loginResponse.data.token;
    
    // Step 2: Verify admin access
    console.log('\n2. Checking admin access...');
    const adminResponse = await axios.get(`${API_BASE_URL}/admin/stats`, {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    });
    
    console.log('✅ Admin access verified');
    console.log(`Stats: ${adminResponse.data.users} users, ${adminResponse.data.listings} listings`);
    
    console.log('\n✅ COMPLETE TEST SUCCESS');
    
  } catch (error) {
    console.error('\n❌ TEST FAILED');
    if (error.response) {
      console.error(`Status: ${error.response.status}`);
      console.error(`Data: ${JSON.stringify(error.response.data)}`);
    } else {
      console.error(error.message);
    }
  }
}

testAdminLogin();
