// Test script to directly validate the admin login API
const fetch = require('node-fetch');

const API_BASE_URL = 'http://localhost:3000/api';
const adminEmail = 'admin@gearted.com';
const adminPassword = 'admin123';

// Add unhandled rejection handler
process.on('unhandledRejection', (reason, promise) => {
  console.error('Unhandled Rejection at:', promise, 'reason:', reason);
  process.exit(1);
});

async function testAdminLogin() {
  console.log(`Testing admin login with ${adminEmail}...`);
  
  try {
    // Step 1: Authenticate using the standard login endpoint
    console.log(`POST ${API_BASE_URL}/auth/login`);
    const loginResponse = await fetch(`${API_BASE_URL}/auth/login`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ email: adminEmail, password: adminPassword }),
    });
    
    console.log(`Login response status: ${loginResponse.status}`);
    
    if (!loginResponse.ok) {
      const errorData = await loginResponse.json().catch(() => ({}));
      console.error('❌ Login failed:', errorData);
      return;
    }
    
    const loginData = await loginResponse.json();
    console.log('✅ Login successful');
    console.log('Token received:', loginData.token ? '✅ Yes' : '❌ No');
    
    if (!loginData.token) {
      console.error('❌ No token received from login');
      return;
    }
    
    // Step 2: Test admin access using the token
    console.log(`\nTesting admin access with token...`);
    console.log(`GET ${API_BASE_URL}/admin/stats`);
    
    const statsResponse = await fetch(`${API_BASE_URL}/admin/stats`, {
      headers: {
        'Authorization': `Bearer ${loginData.token}`,
      },
    });
    
    console.log(`Admin stats response status: ${statsResponse.status}`);
    
    if (!statsResponse.ok) {
      const errorData = await statsResponse.json().catch(() => ({}));
      console.error('❌ Admin access failed:', errorData);
      return;
    }
    
    const statsData = await statsResponse.json();
    console.log('✅ Admin access successful');
    console.log('Stats data received:', statsData ? '✅ Yes' : '❌ No');
    
    if (statsData) {
      console.log('\nAdmin Stats Summary:');
      console.log(`- Users: ${statsData.users}`);
      console.log(`- Listings: ${statsData.listings}`);
      console.log(`- Messages: ${statsData.messages}`);
    }
    
    console.log('\n✅✅✅ Admin login and access test PASSED');
    
  } catch (error) {
    console.error(`\n❌❌❌ Test failed with error: ${error.message}`);
  }
}

// Run the test
testAdminLogin();
