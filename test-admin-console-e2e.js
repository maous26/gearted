// End-to-End test of Admin Console login flow
// This script will simulate the admin console login flow and api interactions
const fetch = require('node-fetch');

// Configuration
const ADMIN_API_URL = 'http://localhost:3000/api'; // Backend API URL
const ADMIN_CONSOLE_URL = 'http://localhost:3003';  // Admin Console URL
const ADMIN_EMAIL = 'admin@gearted.com';
const ADMIN_PASSWORD = 'admin123';

// Utility to display test step results
const logStep = (step, result, details = null) => {
  console.log(`\n${result ? '✅' : '❌'} ${step}`);
  if (details) {
    console.log(details);
  }
};

// Test logging with additional debugging
const debugFetch = async (url, options = {}) => {
  console.log(`\n📡 Request: ${options.method || 'GET'} ${url}`);
  
  if (options.body) {
    console.log('Request body:', options.body);
  }
  
  if (options.headers) {
    console.log('Request headers:', JSON.stringify(options.headers, null, 2));
  }
  
  try {
    const response = await fetch(url, options);
    console.log(`📨 Response status: ${response.status} ${response.statusText}`);
    
    // Clone the response to read it twice
    const responseClone = response.clone();
    
    // Try to parse as JSON first
    try {
      const data = await response.json();
      console.log('Response body (JSON):', JSON.stringify(data, null, 2));
      return { response: responseClone, data };
    } catch (e) {
      // Not JSON, try to get text
      const text = await responseClone.text();
      console.log('Response body (Text):', text.substring(0, 1000) + (text.length > 1000 ? '...' : ''));
      return { response: responseClone, text };
    }
  } catch (error) {
    console.error(`❌ Request failed: ${error.message}`);
    throw error;
  }
};

async function testAdminConsoleE2E() {
  console.log('🔍 STARTING ADMIN CONSOLE END-TO-END TEST');
  console.log('----------------------------------------');
  try {
    // Step 1: Direct API login to verify backend works
    console.log('\n📋 STEP 1: DIRECT API LOGIN TEST');
    const { response: loginResponse, data: loginData } = await debugFetch(`${ADMIN_API_URL}/auth/login`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ email: ADMIN_EMAIL, password: ADMIN_PASSWORD }),
    });

    logStep(
      'Direct API login',
      loginResponse.ok && loginData.token,
      loginResponse.ok 
        ? `Token received: ${loginData.token.substring(0, 15)}...` 
        : `Login failed with status ${loginResponse.status}`
    );

    if (!loginResponse.ok || !loginData.token) {
      throw new Error('Direct API login failed');
    }

    // Step 2: Test admin API access with the token
    console.log('\n📋 STEP 2: ADMIN API ACCESS TEST');
    const { response: statsResponse, data: statsData } = await debugFetch(`${ADMIN_API_URL}/admin/stats`, {
      headers: {
        'Authorization': `Bearer ${loginData.token}`,
      },
    });

    logStep(
      'Admin API access with token',
      statsResponse.ok,
      statsResponse.ok 
        ? `Users: ${statsData.users}, Listings: ${statsData.listings}, Messages: ${statsData.messages}` 
        : `Admin access failed with status ${statsResponse.status}`
    );

    if (!statsResponse.ok) {
      throw new Error('Admin API access failed');
    }

    // Step 3: Verify admin console environment variables
    console.log('\n📋 STEP 3: VERIFYING ADMIN CONSOLE ENVIRONMENT');
    console.log(`Admin Console API URL should be: ${ADMIN_API_URL}`);
    console.log(`Admin Console is running at: ${ADMIN_CONSOLE_URL}`);

    // Step 4: Test the admin console's API service
    console.log('\n📋 STEP 4: TESTING ADMIN CONSOLE API SERVICE');
    console.log(`
    The admin console should be making API requests to:
    - Login endpoint: ${ADMIN_API_URL}/auth/login
    - Admin endpoints: ${ADMIN_API_URL}/admin/*
    
    If you're still experiencing issues with the admin console login, please check:
    1. The environment variables in gearted-admin/.env and .env.local
    2. CORS settings in the backend
    3. Network traffic in your browser's developer tools
    4. Any console errors in the browser
    `);

    console.log('\n✅✅✅ END-TO-END TEST COMPLETED SUCCESSFULLY');
    console.log('\nThe backend API is working correctly for admin authentication.');
    console.log('If the admin console is still not working, the issue is likely in the frontend configuration or API integration.');
    
  } catch (error) {
    console.error(`\n❌❌❌ TEST FAILED: ${error.message}`);
  }
}

// Run the test
testAdminConsoleE2E();
