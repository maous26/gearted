// Test script to verify that the admin login fix works

const fetch = require('node-fetch');
const API_URL = 'http://localhost:3000/api';
const ADMIN_EMAIL = 'admin@gearted.com';
const ADMIN_PASSWORD = 'admin123';

/**
 * Test that admin login works
 */
async function testAdminLogin() {
  try {
    console.log('Testing admin login with credentials:', ADMIN_EMAIL);
    
    // 1. Try to login with admin credentials
    const loginResponse = await fetch(`${API_URL}/auth/login`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        email: ADMIN_EMAIL,
        password: ADMIN_PASSWORD
      })
    });
    
    if (!loginResponse.ok) {
      const errorData = await loginResponse.json();
      console.error('❌ Login failed:', errorData);
      return false;
    }
    
    const loginData = await loginResponse.json();
    const token = loginData.token;
    
    console.log('✅ Login successful, token received');
    
    // 2. Now test admin access by calling the admin stats endpoint
    const statsResponse = await fetch(`${API_URL}/admin/stats`, {
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`
      }
    });
    
    if (!statsResponse.ok) {
      const errorData = await statsResponse.json();
      console.error('❌ Admin access failed:', errorData);
      return false;
    }
    
    const statsData = await statsResponse.json();
    console.log('✅ Admin API access successful, stats retrieved');
    console.log('Stats:', JSON.stringify(statsData, null, 2));
    
    return true;
  } catch (error) {
    console.error('❌ Error during test:', error.message);
    return false;
  }
}

// Run the test
console.log('Starting admin login verification test...');
testAdminLogin()
  .then(success => {
    if (success) {
      console.log('✅ VERIFICATION PASSED: Admin login fix is working correctly');
    } else {
      console.log('❌ VERIFICATION FAILED: Admin login fix is not working correctly');
    }
  });
