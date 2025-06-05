// Final Admin Console Login Fix Script
// This script performs a comprehensive check and fix for admin console login issues

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');
const fetch = require('node-fetch');

// Configuration
const BACKEND_URL = 'http://localhost:3000/api';
const ADMIN_EMAIL = 'admin@gearted.com';
const ADMIN_PASSWORD = 'admin123';

// Terminal colors for better output
const colors = {
  reset: '\x1b[0m',
  bright: '\x1b[1m',
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  cyan: '\x1b[36m'
};

// Logging helpers
const log = (msg) => console.log(msg);
const info = (msg) => console.log(`${colors.blue}ℹ️ ${msg}${colors.reset}`);
const success = (msg) => console.log(`${colors.green}✅ ${msg}${colors.reset}`);
const warning = (msg) => console.log(`${colors.yellow}⚠️ ${msg}${colors.reset}`);
const error = (msg) => console.log(`${colors.red}❌ ${msg}${colors.reset}`);
const header = (msg) => console.log(`\n${colors.bright}${colors.cyan}=== ${msg} ===${colors.reset}\n`);

// File helpers
function readFile(filePath) {
  try {
    return fs.readFileSync(filePath, 'utf8');
  } catch (err) {
    return null;
  }
}

function writeFile(filePath, content) {
  try {
    fs.writeFileSync(filePath, content, 'utf8');
    return true;
  } catch (err) {
    return false;
  }
}

function fileExists(filePath) {
  return fs.existsSync(filePath);
}

// Command execution helpers
function runCommand(command, silentError = false) {
  try {
    return execSync(command, { encoding: 'utf8' });
  } catch (err) {
    if (!silentError) error(`Command failed: ${command}\n${err.message}`);
    return null;
  }
}

// API test helpers
async function testBackendHealth() {
  try {
    info('Testing backend health endpoint...');
    const response = await fetch(`${BACKEND_URL}/health`);
    
    if (response.ok) {
      const data = await response.json();
      success(`Backend health endpoint working. Response: ${JSON.stringify(data)}`);
      return true;
    } else {
      error(`Backend health endpoint returned ${response.status} ${response.statusText}`);
      return false;
    }
  } catch (err) {
    error(`Failed to connect to backend: ${err.message}`);
    return false;
  }
}

async function testAdminLogin() {
  try {
    info(`Attempting admin login with ${ADMIN_EMAIL}...`);
    const response = await fetch(`${BACKEND_URL}/auth/login`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        email: ADMIN_EMAIL,
        password: ADMIN_PASSWORD
      })
    });
    
    if (response.ok) {
      const data = await response.json();
      success(`Admin login successful! Token received.`);
      return { success: true, token: data.token, user: data.user };
    } else {
      const text = await response.text();
      error(`Admin login failed with status ${response.status}: ${text}`);
      return { success: false };
    }
  } catch (err) {
    error(`Admin login request failed: ${err.message}`);
    return { success: false };
  }
}

async function testAdminAccess(token) {
  if (!token) {
    error('No token provided for admin access test');
    return false;
  }
  
  try {
    info('Testing admin API access...');
    const response = await fetch(`${BACKEND_URL}/admin/stats`, {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    });
    
    if (response.ok) {
      const data = await response.json();
      success(`Admin access successful! Stats: ${JSON.stringify(data)}`);
      return true;
    } else {
      error(`Admin access failed with status ${response.status}`);
      return false;
    }
  } catch (err) {
    error(`Admin access request failed: ${err.message}`);
    return false;
  }
}

// Fix helpers
function fixCorsConfiguration() {
  const appTsPath = path.join(__dirname, 'gearted-backend', 'src', 'app.ts');
  
  if (!fileExists(appTsPath)) {
    error(`Could not find app.ts at ${appTsPath}`);
    return false;
  }
  
  info('Checking CORS configuration...');
  let content = readFile(appTsPath);
  
  // Check if all admin console ports are allowed in CORS
  const adminPorts = ['3001', '3002', '3003', '3005'];
  const missingPorts = [];
  
  adminPorts.forEach(port => {
    if (!content.includes(`localhost:${port}`)) {
      missingPorts.push(port);
    }
  });
  
  if (missingPorts.length === 0) {
    success('CORS configuration is properly set up for all admin console ports');
    return true;
  }
  
  warning(`Missing ports in CORS configuration: ${missingPorts.join(', ')}`);
  info('Updating CORS configuration...');
  
  // Find CORS configuration block
  const corsPattern = /app\.use\(cors\(\{[\s\S]+?\}\)\)\);/;
  const corsMatch = content.match(corsPattern);
  
  if (!corsMatch) {
    error('Could not find CORS configuration block in app.ts');
    return false;
  }
  
  // Generate new CORS configuration with all admin ports
  const newCorsConfig = `app.use(cors({
  origin: [
    process.env.CLIENT_URL || 'http://localhost:3000',
    'http://localhost:3001', // Admin console (port 3001)
    'http://localhost:3002', // Admin console (port 3002)
    'http://localhost:3003', // Admin console (port 3003)
    'http://localhost:3005'  // Admin console (port 3005)
  ],
  credentials: true,
}));`;
  
  content = content.replace(corsMatch[0], newCorsConfig);
  
  if (writeFile(appTsPath, content)) {
    success('CORS configuration updated successfully');
    info('You need to restart the backend server for changes to take effect');
    return true;
  } else {
    error('Failed to update CORS configuration');
    return false;
  }
}

function checkAdminEnvironment() {
  const envPath = path.join(__dirname, 'gearted-backend', '.env');
  
  if (!fileExists(envPath)) {
    error(`Could not find .env file at ${envPath}`);
    return false;
  }
  
  info('Checking admin environment variables...');
  let content = readFile(envPath);
  let modified = false;
  
  // Check ADMIN_EMAIL
  if (!content.includes('ADMIN_EMAIL=')) {
    info('Adding ADMIN_EMAIL to .env file...');
    content += `\nADMIN_EMAIL=${ADMIN_EMAIL}\n`;
    modified = true;
  }
  
  if (modified) {
    if (writeFile(envPath, content)) {
      success('Environment variables updated');
      return true;
    } else {
      error('Failed to update environment variables');
      return false;
    }
  }
  
  success('Admin environment variables are properly configured');
  return true;
}

function checkAdminConsoleEnvironment() {
  const adminEnvPath = path.join(__dirname, 'gearted-admin', '.env');
  const adminEnvLocalPath = path.join(__dirname, 'gearted-admin', '.env.local');
  
  // Always ensure API URL is correctly set in both files
  const apiUrl = 'NEXT_PUBLIC_API_URL=http://localhost:3000/api';
  
  info('Checking admin console environment files...');
  
  // Update or create .env
  const envContent = fileExists(adminEnvPath) ? readFile(adminEnvPath) : '';
  if (!envContent.includes('NEXT_PUBLIC_API_URL=')) {
    info('Adding API URL to .env file...');
    const newContent = envContent + '\n' + apiUrl + '\n';
    if (writeFile(adminEnvPath, newContent)) {
      success('Updated .env file with API URL');
    } else {
      error('Failed to update .env file');
    }
  }
  
  // Update or create .env.local
  const envLocalContent = fileExists(adminEnvLocalPath) ? readFile(adminEnvLocalPath) : '';
  if (!envLocalContent.includes('NEXT_PUBLIC_API_URL=')) {
    info('Adding API URL to .env.local file...');
    const newContent = envLocalContent + '\n' + apiUrl + '\n';
    if (writeFile(adminEnvLocalPath, newContent)) {
      success('Updated .env.local file with API URL');
    } else {
      error('Failed to update .env.local file');
    }
  }
  
  success('Admin console environment is properly configured');
  return true;
}

function restartBackendServer() {
  info('Attempting to restart the backend server...');
  
  // First check if server is running
  const isRunning = runCommand('lsof -i :3000 -sTCP:LISTEN', true);
  
  if (isRunning) {
    info('Backend server is running. Stopping it...');
    runCommand('pkill -f "node.*gearted-backend"');
  }
  
  info('Starting backend server...');
  
  // Run in background
  const backendPath = path.join(__dirname, 'gearted-backend');
  const command = `cd "${backendPath}" && npm run dev:safe`;
  
  try {
    if (process.platform === 'win32') {
      // Windows - use start command
      runCommand(`start cmd /c "${command}"`);
    } else {
      // Unix - use nohup
      runCommand(`nohup ${command} > backend.log 2>&1 &`);
    }
    
    success('Backend server restart initiated');
    info('Waiting for backend to start...');
    
    // Give it some time to start
    return new Promise(resolve => {
      setTimeout(resolve, 5000);
    });
  } catch (err) {
    error(`Failed to restart backend server: ${err.message}`);
    return Promise.resolve();
  }
}

// Main function
async function main() {
  header('ADMIN CONSOLE AUTHENTICATION FIX');
  
  // Step 1: Check backend connectivity
  const isHealthy = await testBackendHealth();
  if (!isHealthy) {
    warning('Backend API is not accessible. Attempting fixes...');
    
    // Fix CORS and environment variables
    fixCorsConfiguration();
    checkAdminEnvironment();
    
    // Restart backend server
    await restartBackendServer();
    
    // Verify connectivity again
    const isNowHealthy = await testBackendHealth();
    if (!isNowHealthy) {
      error('Backend still not accessible after fixes. Please check backend server logs.');
      return;
    }
  }
  
  // Step 2: Test admin login
  const loginResult = await testAdminLogin();
  if (!loginResult.success) {
    warning('Admin login failed. Checking configuration...');
    checkAdminEnvironment();
    
    // Try login again
    const retryLogin = await testAdminLogin();
    if (!retryLogin.success) {
      error('Admin login still failing. Please check if admin user exists in database.');
      return;
    } else {
      loginResult.token = retryLogin.token;
      loginResult.user = retryLogin.user;
    }
  }
  
  // Step 3: Test admin access
  const adminAccessOk = await testAdminAccess(loginResult.token);
  if (!adminAccessOk) {
    error('Admin access issues. Verify admin middleware is working correctly.');
  }
  
  // Step 4: Check admin console environment
  checkAdminConsoleEnvironment();
  
  // Final summary
  header('FIX SUMMARY');
  log('Backend health check:', isHealthy ? '✅ Passed' : '❌ Failed');
  log('Admin login:', loginResult.success ? '✅ Passed' : '❌ Failed');
  log('Admin access:', adminAccessOk ? '✅ Passed' : '❌ Failed');
  
  if (isHealthy && loginResult.success && adminAccessOk) {
    success('\nALL CHECKS PASSED! Admin console authentication should now be working.');
    info('If you still experience issues, try the following:');
    log('1. Restart both the backend and admin console applications');
    log('2. Clear browser cache and cookies');
    log('3. Check browser console for any remaining errors');
    log('4. Verify network traffic in browser developer tools');
  } else {
    warning('\nSome checks failed. Please review the output above for details.');
  }
}

// Run the script
main().catch(err => {
  error(`Script error: ${err.message}`);
});
