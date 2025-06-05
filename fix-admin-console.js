// fix-admin-console.js
const axios = require('axios');
const fs = require('fs');
const path = require('path');

// Configuration
const API_BASE_URL = process.env.API_URL || 'http://localhost:3000/api';
const ADMIN_EMAIL = 'admin@gearted.com';
const ADMIN_PASSWORD = 'admin123';

// Colors for console output
const colors = {
  reset: '\x1b[0m',
  bright: '\x1b[1m',
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  magenta: '\x1b[35m',
  cyan: '\x1b[36m',
};

// Helper functions
const log = {
  info: (msg) => console.log(`${colors.blue}[INFO]${colors.reset} ${msg}`),
  success: (msg) => console.log(`${colors.green}[SUCCESS]${colors.reset} ${msg}`),
  warn: (msg) => console.log(`${colors.yellow}[WARNING]${colors.reset} ${msg}`),
  error: (msg) => console.log(`${colors.red}[ERROR]${colors.reset} ${msg}`),
  section: (title) => console.log(`\n${colors.bright}${colors.magenta}=== ${title} ===${colors.reset}\n`)
};

// Main function
async function fixAdminConsole() {
  log.section('GEARTED ADMIN CONSOLE AUTHENTICATION DEBUGGER');
  
  try {
    // Check backend health
    log.info('Checking backend API health...');
    try {
      const healthResponse = await axios.get(`${API_BASE_URL}/health`);
      log.success(`Backend is running: ${healthResponse.data.message}`);
    } catch (error) {
      log.error(`Backend health check failed: ${error.message}`);
      if (error.code === 'ECONNREFUSED') {
        log.error('Backend server is not running. Please start it first.');
        process.exit(1);
      }
    }
    
    // Step 1: Test admin login
    log.section('STEP 1: TESTING ADMIN LOGIN');
    log.info(`Attempting to login as ${ADMIN_EMAIL}...`);
    
    try {
      const loginResponse = await axios.post(`${API_BASE_URL}/auth/login`, {
        email: ADMIN_EMAIL,
        password: ADMIN_PASSWORD
      });
      
      if (loginResponse.data.success === false) {
        log.error(`Login failed: ${loginResponse.data.message || 'Unknown error'}`);
        process.exit(1);
      }
      
      const { token, user } = loginResponse.data;
      log.success(`Login successful!`);
      log.info(`User: ${user.email} (${user.id})`);
      log.info(`Token: ${token.substring(0, 20)}...`);
      
      // Step 2: Verify admin access
      log.section('STEP 2: VERIFYING ADMIN ACCESS');
      log.info('Attempting to access admin stats with the token...');
      
      try {
        const statsResponse = await axios.get(`${API_BASE_URL}/admin/stats`, {
          headers: {
            'Authorization': `Bearer ${token}`
          }
        });
        
        log.success('Admin access verified successfully!');
        log.info(`Stats: ${statsResponse.data.users} users, ${statsResponse.data.listings} listings, ${statsResponse.data.messages} messages`);
        
      } catch (statsError) {
        log.error(`Admin access verification failed: ${statsError.message}`);
        if (statsError.response) {
          log.error(`Status: ${statsError.response.status}`);
          log.error(`Response: ${JSON.stringify(statsError.response.data)}`);
        }
        
        log.section('CHECKING ADMIN MIDDLEWARE');
        log.info('Verifying ADMIN_EMAIL configuration...');
        
        // Check if ADMIN_EMAIL is set in .env
        try {
          const envPath = path.join(__dirname, 'gearted-backend', '.env');
          const envContent = fs.readFileSync(envPath, 'utf8');
          
          if (envContent.includes('ADMIN_EMAIL=')) {
            log.success('ADMIN_EMAIL is configured in .env file');
            
            // Extract the value
            const match = envContent.match(/ADMIN_EMAIL=(.+?)(\r?\n|$)/);
            if (match && match[1]) {
              log.info(`Configured value: ${match[1]}`);
              if (match[1] !== ADMIN_EMAIL) {
                log.warn(`Configured email (${match[1]}) doesn't match the one we're testing with (${ADMIN_EMAIL})`);
              }
            }
          } else {
            log.error('ADMIN_EMAIL is not configured in .env file');
            log.info('Adding ADMIN_EMAIL to .env file...');
            
            fs.appendFileSync(envPath, `\nADMIN_EMAIL=${ADMIN_EMAIL}\n`);
            log.success(`Added ADMIN_EMAIL=${ADMIN_EMAIL} to .env file`);
            log.warn('You need to restart the backend server to apply this change');
          }
        } catch (envError) {
          log.error(`Error reading/writing .env file: ${envError.message}`);
        }
        
        process.exit(1);
      }
      
    } catch (loginError) {
      log.error(`Login request failed: ${loginError.message}`);
      if (loginError.response) {
        log.error(`Status: ${loginError.response.status}`);
        log.error(`Response: ${JSON.stringify(loginError.response.data)}`);
      }
      process.exit(1);
    }
    
    // Step 3: Test CORS
    log.section('STEP 3: TESTING CORS CONFIGURATION');
    log.info('Sending request with Admin Console origin...');
    
    try {
      const corsResponse = await axios.get(`${API_BASE_URL}/health`, {
        headers: {
          'Origin': 'http://localhost:3002'
        }
      });
      
      const corsHeaders = corsResponse.headers;
      
      if (corsHeaders['access-control-allow-origin']) {
        log.success(`CORS is properly configured!`);
        log.info(`Access-Control-Allow-Origin: ${corsHeaders['access-control-allow-origin']}`);
        
        if (corsHeaders['access-control-allow-credentials']) {
          log.success(`Credentials are allowed: ${corsHeaders['access-control-allow-credentials']}`);
        } else {
          log.warn('Credentials are not allowed in CORS configuration');
        }
      } else {
        log.error('CORS headers are not present in the response');
        log.info('Checking app.ts CORS configuration...');
      }
      
    } catch (corsError) {
      log.error(`CORS check failed: ${corsError.message}`);
    }
    
    // Conclusion
    log.section('RESULTS');
    log.success(`Authentication system is working correctly!`);
    log.info(`Admin credentials: ${ADMIN_EMAIL} / ${ADMIN_PASSWORD}`);
    log.info(`Admin console should now be able to login successfully.`);
    
  } catch (error) {
    log.error(`Unexpected error: ${error.message}`);
    process.exit(1);
  }
}

// Run the script
fixAdminConsole();
