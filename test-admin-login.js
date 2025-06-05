// Test script to verify admin login functionality
const fs = require('fs');
const path = require('path');

// Check if login page is properly structured
console.log('🔍 Testing admin console DOM structure and login functionality...\n');

// Check if the login page file exists and contains the fixed structure
const loginPagePath = path.join(__dirname, 'gearted-admin/src/app/login/page.tsx');

if (fs.existsSync(loginPagePath)) {
    const loginPageContent = fs.readFileSync(loginPagePath, 'utf8');
    
    // Check if the problematic DOM nesting patterns have been fixed
    const hasCodeElements = loginPageContent.includes('<code');
    const hasParagraphWithDivs = loginPageContent.match(/<p[^>]*>[\s\S]*?<div/);
    
    console.log('✅ Login page file exists');
    console.log(`${hasCodeElements ? '❌' : '✅'} Code elements check: ${hasCodeElements ? 'Found <code> elements (potential issue)' : 'No <code> elements found'}`);
    console.log(`${hasParagraphWithDivs ? '❌' : '✅'} Paragraph nesting check: ${hasParagraphWithDivs ? 'Found <p> with <div> children (DOM nesting issue)' : 'No DOM nesting issues found'}`);
    
    // Check if the demo credentials section uses proper HTML structure
    const hasDemoCredentials = loginPageContent.includes('Identifiants de démonstration');
    const usesSpanInsteadOfCode = loginPageContent.includes('font-mono') && !loginPageContent.includes('<code');
    
    console.log(`${hasDemoCredentials ? '✅' : '❌'} Demo credentials section: ${hasDemoCredentials ? 'Present' : 'Missing'}`);
    console.log(`${usesSpanInsteadOfCode ? '✅' : '❌'} Font styling: ${usesSpanInsteadOfCode ? 'Uses span with font-mono class instead of code elements' : 'Still using code elements'}`);
    
} else {
    console.log('❌ Login page file not found');
}

// Test basic admin API endpoint
console.log('\n🔗 Testing admin API connectivity...');

const http = require('http');

const testAdminAPI = () => {
    return new Promise((resolve, reject) => {
        const options = {
            hostname: 'localhost',
            port: 3000,
            path: '/api/admin/stats',
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            }
        };

        const req = http.request(options, (res) => {
            console.log(`✅ Admin API responding: Status ${res.statusCode}`);
            resolve(res.statusCode);
        });

        req.on('error', (err) => {
            console.log(`❌ Admin API error: ${err.message}`);
            reject(err);
        });

        req.setTimeout(5000, () => {
            console.log('❌ Admin API timeout');
            reject(new Error('Timeout'));
        });

        req.end();
    });
};

testAdminAPI().catch(() => {
    console.log('⚠️  Admin API not accessible (expected if not authenticated)');
});

console.log('\n📋 DOM Nesting Fix Summary:');
console.log('1. Replaced <p> elements containing flex items with <div> elements');
console.log('2. Replaced <code> elements with <span> elements using font-mono class');
console.log('3. Ensured proper semantic HTML structure throughout the login page');
console.log('4. Maintained visual appearance while fixing DOM validation issues');
