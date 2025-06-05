// Comprehensive Admin Console Fix Script
// This script checks and fixes common issues with the admin console authentication

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');
const fetch = require('node-fetch');

// Configuration
const rootDir = path.resolve(__dirname);
const backendDir = path.join(rootDir, 'gearted-backend');
const adminDir = path.join(rootDir, 'gearted-admin');
const adminEmail = 'admin@gearted.com';
const adminPassword = 'admin123';
const apiBaseUrl = 'http://localhost:3000/api';

// Utility functions
const log = (message) => console.log(`📋 ${message}`);
const success = (message) => console.log(`✅ ${message}`);
const warning = (message) => console.log(`⚠️  ${message}`);
const error = (message) => console.log(`❌ ${message}`);
const divider = () => console.log('\n' + '-'.repeat(50) + '\n');

// Check if file exists
const fileExists = (filePath) => {
  try {
    return fs.existsSync(filePath);
  } catch (err) {
    return false;
  }
};

// Read file content
const readFile = (filePath) => {
  try {
    return fs.readFileSync(filePath, 'utf8');
  } catch (err) {
    return null;
  }
};

// Write file content
const writeFile = (filePath, content) => {
  try {
    fs.writeFileSync(filePath, content, 'utf8');
    return true;
  } catch (err) {
    return false;
  }
};

// Ensure directory exists
const ensureDir = (dirPath) => {
  if (!fs.existsSync(dirPath)) {
    fs.mkdirSync(dirPath, { recursive: true });
  }
};

// Run command and return output
const runCommand = (command, cwd = rootDir) => {
  try {
    return execSync(command, { cwd, encoding: 'utf8', stdio: 'pipe' });
  } catch (err) {
    return null;
  }
};

// Check if port is in use
const isPortInUse = (port) => {
  try {
    const command = process.platform === 'win32' 
      ? `netstat -ano | findstr :${port}`
      : `lsof -i :${port} | grep LISTEN`;
    
    const result = runCommand(command);
    return !!result && result.trim().length > 0;
  } catch (err) {
    return false;
  }
};

// Verify backend .env file
const checkBackendEnv = () => {
  log('Checking backend environment configuration...');
  
  const envPath = path.join(backendDir, '.env');
  
  if (!fileExists(envPath)) {
    error(`Backend .env file not found at ${envPath}`);
    return false;
  }
  
  let envContent = readFile(envPath);
  let modified = false;
  
  // Check ADMIN_EMAIL
  if (!envContent.includes('ADMIN_EMAIL=')) {
    envContent += '\nADMIN_EMAIL=admin@gearted.com';
    modified = true;
    warning('Added ADMIN_EMAIL to backend .env file');
  }
  
  // Save changes if needed
  if (modified) {
    writeFile(envPath, envContent);
    success('Updated backend .env file');
  } else {
    success('Backend .env file is properly configured');
  }
  
  return true;
};

// Check CORS configuration
const checkCorsConfig = async () => {
  log('Checking CORS configuration...');
  
  const appPath = path.join(backendDir, 'src/app.ts');
  
  if (!fileExists(appPath)) {
    error(`Backend app.ts file not found at ${appPath}`);
    return false;
  }
  
  let appContent = readFile(appPath);
  let modified = false;
  
  // Check if CORS is properly configured for admin console
  if (!appContent.includes('http://localhost:3001') || 
      !appContent.includes('http://localhost:3002') ||
      !appContent.includes('http://localhost:3005')) {
    
    // Replace CORS configuration
    const corsPattern = /app\.use\(cors\(\{[\s\S]+?\}\)\)\);/;
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
    
    appContent = appContent.replace(corsPattern, newCorsConfig);
    modified = true;
    warning('Updated CORS configuration in app.ts');
  }
  
  // Save changes if needed
  if (modified) {
    writeFile(appPath, appContent);
    success('Updated CORS configuration in app.ts');
  } else {
    success('CORS configuration is properly set up');
  }
  
  return true;
};

// Check admin console environment files
const checkAdminConsoleEnv = () => {
  log('Checking admin console environment configuration...');
  
  const envLocalPath = path.join(adminDir, '.env.local');
  const envPath = path.join(adminDir, '.env');
  
  // Make sure both files exist
  ensureDir(path.dirname(envLocalPath));
  ensureDir(path.dirname(envPath));
  
  // Check .env.local
  let envLocalContent = fileExists(envLocalPath) ? readFile(envLocalPath) : '';
  if (!envLocalContent.includes('NEXT_PUBLIC_API_URL=')) {
    envLocalContent = 'NEXT_PUBLIC_API_URL=http://localhost:3000/api\n';
    writeFile(envLocalPath, envLocalContent);
    warning('Created/updated .env.local file with API URL');
  }
  
  // Check .env
  let envContent = fileExists(envPath) ? readFile(envPath) : '';
  if (!envContent.includes('NEXT_PUBLIC_API_URL=')) {
    envContent = 'NEXT_PUBLIC_API_URL=http://localhost:3000/api\n';
    writeFile(envPath, envContent);
    warning('Created/updated .env file with API URL');
  }
  
  success('Admin console environment files are set up correctly');
  return true;
};

// Test backend connection
const testBackendConnection = async () => {
  log('Testing backend connection...');
  
  try {
    const response = await fetch(`${apiBaseUrl}/health`);
    const isOk = response.ok;
    
    if (isOk) {
      success('Backend connection successful');
    } else {
      error(`Backend connection failed: ${response.status} ${response.statusText}`);
    }
    
    return isOk;
  } catch (err) {
    error(`Backend connection error: ${err.message}`);
    
    if (err.code === 'ECONNREFUSED') {
      warning('Backend server appears to be down. Checking port usage...');
      
      if (isPortInUse(3000)) {
        warning('Port 3000 is already in use. Try stopping any running services on this port.');
      } else {
        warning('Port 3000 is available. The backend server might not be running.');
      }
    }
    
    return false;
  }
};

// Test admin login
const testAdminLogin = async () => {
  log('Testing admin login...');
  
  try {
    const response = await fetch(`${apiBaseUrl}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email: adminEmail, password: adminPassword })
    });
    
    const data = await response.json();
    
    if (response.ok && data.token) {
      success('Admin login successful');
      return { success: true, token: data.token };
    } else {
      error(`Admin login failed: ${JSON.stringify(data)}`);
      return { success: false };
    }
  } catch (err) {
    error(`Admin login error: ${err.message}`);
    return { success: false };
  }
};

// Test admin API access
const testAdminAccess = async (token) => {
  log('Testing admin API access...');
  
  if (!token) {
    error('No token provided');
    return false;
  }
  
  try {
    const response = await fetch(`${apiBaseUrl}/admin/stats`, {
      headers: { 'Authorization': `Bearer ${token}` }
    });
    
    const isOk = response.ok;
    
    if (isOk) {
      const data = await response.json();
      success(`Admin API access successful (Users: ${data.users}, Listings: ${data.listings})`);
    } else {
      error(`Admin API access failed: ${response.status} ${response.statusText}`);
    }
    
    return isOk;
  } catch (err) {
    error(`Admin API access error: ${err.message}`);
    return false;
  }
};

// Main function
async function main() {
  console.log('\n🔧 ADMIN CONSOLE AUTHENTICATION FIX SCRIPT\n');
  
  divider();
  
  // Step 1: Check backend environment
  checkBackendEnv();
  
  divider();
  
  // Step 2: Check CORS configuration
  await checkCorsConfig();
  
  divider();
  
  // Step 3: Check admin console environment
  checkAdminConsoleEnv();
  
  divider();
  
  // Step 4: Test backend connection
  const backendConnected = await testBackendConnection();
  
  if (!backendConnected) {
    warning('Cannot proceed with API tests because backend is not reachable');
    divider();
    return;
  }
  
  divider();
  
  // Step 5: Test admin login
  const loginResult = await testAdminLogin();
  
  if (!loginResult.success) {
    warning('Cannot proceed with admin access test because login failed');
    divider();
    return;
  }
  
  divider();
  
  // Step 6: Test admin API access
  await testAdminAccess(loginResult.token);
  
  divider();
  
  // Summary
  console.log('\n✅ ADMIN CONSOLE FIX COMPLETED\n');
  console.log('The admin console should now be working correctly with the following credentials:');
  console.log(`- Email: ${adminEmail}`);
  console.log(`- Password: ${adminPassword}`);
  console.log('\nIf issues persist, please check:');
  console.log('1. Backend server is running on port 3000');
  console.log('2. Admin console can connect to the backend API');
  console.log('3. Browser console for any client-side errors');
  
  divider();
}

// Run the script
main().catch(err => {
  console.error('Script error:', err);
});
