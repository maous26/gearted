// simple-admin-test.js
const axios = require('axios');

// Configuration
const API_BASE_URL = 'http://localhost:3000/api';
const ADMIN_EMAIL = 'admin@gearted.com';
const ADMIN_PASSWORD = 'admin123';

async function testAdminLogin() {
  console.log(`Testing admin login for ${ADMIN_EMAIL}...`);
  
  try {
    // Step 1: Login
    console.log('\nStep 1: Testing login...');
    const loginResponse = await axios.post(`${API_BASE_URL}/auth/login`, {
      email: ADMIN_EMAIL,
      password: ADMIN_PASSWORD
    });
    
    console.log('Login successful!');
    console.log(`Status: ${loginResponse.status}`);
    console.log(`Token: ${loginResponse.data.token.substring(0, 20)}...`);
    
    const token = loginResponse.data.token;
    
    // Step 2: Admin access
    console.log('\nStep 2: Testing admin access...');
    const statsResponse = await axios.get(`${API_BASE_URL}/admin/stats`, {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    });
    
    console.log('Admin access successful!');
    console.log(`Users: ${statsResponse.data.users}`);
    console.log(`Listings: ${statsResponse.data.listings}`);
    
  } catch (error) {
    console.error('\nERROR:');
    if (error.response) {
      console.error(`Status: ${error.response.status}`);
      console.error(`Data: ${JSON.stringify(error.response.data, null, 2)}`);
    } else if (error.request) {
      console.error('No response received, server might be down');
    } else {
      console.error(error.message);
    }
  }
}

testAdminLogin();
