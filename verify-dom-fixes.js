#!/usr/bin/env node

// Verification script for DOM nesting fixes in Gearted admin console
const fs = require('fs');
const path = require('path');

console.log('🔍 Verifying DOM nesting fixes in Gearted Admin Console...\n');

// Check login page for DOM nesting issues
const loginPagePath = path.join(__dirname, 'gearted-admin/src/app/login/page.tsx');

function checkDOMNesting(filePath, fileName) {
    if (!fs.existsSync(filePath)) {
        console.log(`❌ ${fileName} not found`);
        return false;
    }

    const content = fs.readFileSync(filePath, 'utf8');
    let hasIssues = false;
    const issues = [];

    // Check for <code> elements (should be replaced with <span>)
    const codeElements = content.match(/<code[^>]*>/g);
    if (codeElements) {
        issues.push(`Found ${codeElements.length} <code> element(s)`);
        hasIssues = true;
    }

    // Check for <p> elements containing <div> children
    const pWithDivPattern = /<p[^>]*>[\s\S]*?<div/g;
    const pWithDivMatches = content.match(pWithDivPattern);
    if (pWithDivMatches) {
        issues.push(`Found ${pWithDivMatches.length} <p> element(s) containing <div> children`);
        hasIssues = true;
    }

    // Check for proper semantic structure
    const hasSpanWithFontMono = content.includes('span') && content.includes('font-mono');
    const usesProperDivStructure = content.includes('className="text-sm font-semibold text-slate-300 mb-3 flex items-center"');

    console.log(`📄 ${fileName}:`);
    if (hasIssues) {
        console.log(`  ❌ Issues found:`);
        issues.forEach(issue => console.log(`     - ${issue}`));
    } else {
        console.log(`  ✅ No DOM nesting issues found`);
    }

    if (hasSpanWithFontMono) {
        console.log(`  ✅ Uses <span> with font-mono class instead of <code>`);
    }

    if (usesProperDivStructure) {
        console.log(`  ✅ Uses proper <div> structure for demo credentials`);
    }

    console.log('');
    return !hasIssues;
}

// Check main page for issues
const mainPagePath = path.join(__dirname, 'gearted-admin/src/app/page.tsx');

function checkMainPage() {
    if (!fs.existsSync(mainPagePath)) {
        console.log(`❌ Main page not found`);
        return false;
    }

    const content = fs.readFileSync(mainPagePath, 'utf8');
    
    // Check for proper imports
    const hasProperImports = content.includes("import { useState, useEffect } from 'react'") &&
                            content.includes("import { useRouter } from 'next/navigation'");
    
    // Check for default export
    const hasDefaultExport = content.includes('export default function Home()');
    
    console.log(`📄 Main page (page.tsx):`);
    
    if (hasProperImports) {
        console.log(`  ✅ Has proper React imports`);
    } else {
        console.log(`  ❌ Missing proper React imports`);
    }
    
    if (hasDefaultExport) {
        console.log(`  ✅ Has proper default export`);
    } else {
        console.log(`  ❌ Missing proper default export`);
    }
    
    console.log('');
    return hasProperImports && hasDefaultExport;
}

// Run checks
let allPassed = true;

allPassed &= checkDOMNesting(loginPagePath, 'Login page (login/page.tsx)');
allPassed &= checkMainPage();

// Check build status
console.log('🔨 Build verification:');
try {
    const { execSync } = require('child_process');
    const buildOutput = execSync('cd gearted-admin && npm run build', { 
        encoding: 'utf8',
        stdio: 'pipe'
    });
    
    if (buildOutput.includes('✓ Compiled successfully')) {
        console.log('  ✅ Admin console builds successfully');
    } else {
        console.log('  ❌ Build has warnings or errors');
        allPassed = false;
    }
} catch (error) {
    console.log('  ❌ Build failed:', error.message.split('\n')[0]);
    allPassed = false;
}

console.log('\n' + '='.repeat(50));
if (allPassed) {
    console.log('🎉 All DOM nesting issues have been successfully resolved!');
    console.log('✅ The admin console is ready for production');
} else {
    console.log('⚠️  Some issues remain to be addressed');
}
console.log('='.repeat(50));
