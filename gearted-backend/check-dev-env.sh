#!/bin/bash

# Gearted Development Environment Status Checker
# This script verifies that all components are ready for development

echo "🔍 GEARTED DEVELOPMENT ENVIRONMENT STATUS CHECK"
echo "=============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ $2${NC}"
    else
        echo -e "${RED}❌ $2${NC}"
    fi
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check Node.js
echo ""
echo "📋 System Requirements:"
node --version >/dev/null 2>&1
print_status $? "Node.js: $(node --version 2>/dev/null || echo 'Not installed')"

npm --version >/dev/null 2>&1
print_status $? "NPM: $(npm --version 2>/dev/null || echo 'Not installed')"

# Check MongoDB
echo ""
echo "🗄️  Database Services:"
brew services list | grep mongodb-community | grep started >/dev/null 2>&1
MONGO_SERVICE_STATUS=$?
print_status $MONGO_SERVICE_STATUS "MongoDB Service: $(brew services list | grep mongodb-community | awk '{print $2}' || echo 'Unknown')"

# Test MongoDB connection (simplified)
if command -v mongosh >/dev/null 2>&1; then
    print_status 0 "MongoDB CLI (mongosh) available"
    # Skip detailed connection test to avoid hanging
    if nc -z localhost 27017 2>/dev/null; then
        print_status 0 "MongoDB port 27017 is accessible"
    else
        print_status 1 "MongoDB port 27017 not accessible"
    fi
else
    print_status 1 "MongoDB CLI (mongosh) not found"
fi

# Check if dependencies are installed
echo ""
echo "📦 Project Dependencies:"
if [ -d "node_modules" ]; then
    print_status 0 "Node modules installed"
else
    print_status 1 "Node modules not installed"
    print_warning "Run 'npm install' to install dependencies"
fi

# Check environment configuration
echo ""
echo "⚙️  Configuration:"
if [ -f ".env" ]; then
    print_status 0 ".env file exists"
    if grep -q "DB_URI=mongodb://localhost:27017/gearted" .env; then
        print_status 0 "Database URI configured for local development"
    else
        print_status 1 "Database URI not configured for local development"
        print_warning "Expected: DB_URI=mongodb://localhost:27017/gearted"
    fi
else
    print_status 1 ".env file missing"
    print_warning "Create .env file with required configuration"
fi

# Check port availability
echo ""
echo "🌐 Network Status:"
PORT=3000
lsof -i :$PORT >/dev/null 2>&1
if [ $? -eq 0 ]; then
    PROCESS_INFO=$(lsof -i :$PORT | tail -1 | awk '{print $1 " (PID: " $2 ")"}')
    print_status 0 "Port $PORT is in use by: $PROCESS_INFO"
    print_info "Server appears to be running"
    
    # Test server response
    curl -s http://localhost:$PORT/api/health >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        print_status 0 "Server responding at http://localhost:$PORT"
    else
        print_status 1 "Server not responding at http://localhost:$PORT"
    fi
else
    print_status 1 "Port $PORT is available (server not running)"
    print_info "Use 'npm run dev' or 'npm run dev:safe' to start the server"
fi

# Check mobile app configuration
echo ""
echo "📱 Mobile App Integration:"
MOBILE_ENV_PATH="../gearted-mobile/.env"
if [ -f "$MOBILE_ENV_PATH" ]; then
    print_status 0 "Mobile app .env file exists"
    if grep -q "API_BASE_URL=http://localhost:3000" "$MOBILE_ENV_PATH"; then
        print_status 0 "Mobile app configured for local backend"
    else
        print_status 1 "Mobile app not configured for local backend"
        print_warning "Expected: API_BASE_URL=http://localhost:3000"
    fi
else
    print_status 1 "Mobile app .env file missing"
    print_warning "Create $MOBILE_ENV_PATH for mobile development"
fi

# Summary
echo ""
echo "📊 SUMMARY:"
echo "=========="

# Count issues
ISSUES=0

# Critical checks
if [ $MONGO_SERVICE_STATUS -ne 0 ] || [ $MONGO_CONNECTION_STATUS -ne 0 ]; then
    ISSUES=$((ISSUES + 1))
    print_warning "Database issues detected"
fi

if [ ! -d "node_modules" ]; then
    ISSUES=$((ISSUES + 1))
    print_warning "Dependencies not installed"
fi

if [ ! -f ".env" ]; then
    ISSUES=$((ISSUES + 1))
    print_warning "Environment configuration missing"
fi

if [ $ISSUES -eq 0 ]; then
    echo -e "${GREEN}🎉 Development environment is ready!${NC}"
    echo -e "${GREEN}🚀 You can start developing with: npm run dev:safe${NC}"
else
    echo -e "${RED}⚠️  Found $ISSUES issue(s) that need attention${NC}"
    echo -e "${YELLOW}💡 Fix the issues above before starting development${NC}"
fi

echo ""
echo "🔗 Quick Commands:"
echo "  npm run dev:safe    - Start server with port cleanup"
echo "  npm run kill-port   - Kill processes on port 3000"
echo "  npm run check       - Run this environment check"
echo ""
