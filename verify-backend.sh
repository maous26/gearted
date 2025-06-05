#!/bin/bash
# Verify backend server is running and accessible

echo "🔍 Checking if backend server is running..."

# Check if port 3000 is in use
if lsof -i :3000 -sTCP:LISTEN >/dev/null 2>&1; then
    echo "✅ Backend server is running on port 3000"
else
    echo "❌ Backend server is NOT running on port 3000"
    echo "ℹ️  Starting backend server..."
    
    # Navigate to backend directory and start server
    cd "$(dirname "$0")/gearted-backend" || exit
    
    # Check if we can use dev:safe script
    if grep -q "dev:safe" package.json; then
        echo "▶️  Running npm run dev:safe"
        npm run dev:safe &
    else
        echo "▶️  Running npm run dev"
        npm run dev &
    fi
    
    # Wait for server to start
    echo "⏳ Waiting for server to start..."
    for i in {1..30}; do
        if lsof -i :3000 -sTCP:LISTEN >/dev/null 2>&1; then
            echo "✅ Backend server started successfully"
            break
        fi
        sleep 1
        if [ $i -eq 30 ]; then
            echo "❌ Failed to start backend server"
            exit 1
        fi
    done
fi

# Test backend connectivity
echo "🔍 Testing backend connectivity..."
response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/api/health 2>/dev/null)

if [ "$response" = "200" ]; then
    echo "✅ Backend API is accessible"
else
    echo "❌ Backend API is not accessible (Response code: $response)"
    echo "ℹ️  This might be due to:"
    echo "   - The server is still starting up"
    echo "   - There's no /api/health endpoint"
    echo "   - The server is running but configured differently"
    echo ""
    echo "🔍 Trying a different endpoint..."
    
    # Try the auth endpoint
    auth_response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/api/auth/check 2>/dev/null)
    if [ "$auth_response" != "000" ]; then
        echo "✅ Backend API responded on auth endpoint (Response code: $auth_response)"
    else
        echo "❌ Backend API is not accessible on any tested endpoints"
        echo "ℹ️  Please check the backend server logs for errors"
    fi
fi

# Check CORS configuration
echo "🔍 Checking CORS configuration..."
cors_file="$(dirname "$0")/gearted-backend/src/app.ts"

if [ -f "$cors_file" ]; then
    echo "📄 Found CORS configuration file: $cors_file"
    
    # Check if file contains localhost:3003 (admin console port)
    if grep -q "localhost:3003" "$cors_file"; then
        echo "✅ CORS configuration includes admin console port 3003"
    else
        echo "❌ CORS configuration doesn't include admin console port 3003"
        echo "ℹ️  Admin console will likely encounter CORS errors"
        
        # Update CORS configuration
        echo "📝 Updating CORS configuration..."
        sed -i'' -e 's/\(origin: \[\)/\1\n    '"'http:\/\/localhost:3003', \/\/ Admin console"'/' "$cors_file"
        
        # Check if update was successful
        if grep -q "localhost:3003" "$cors_file"; then
            echo "✅ CORS configuration updated successfully"
            echo "ℹ️  You need to restart the backend server for changes to take effect"
        else
            echo "❌ Failed to update CORS configuration"
        fi
    fi
else
    echo "❌ Could not find CORS configuration file"
fi

# Check admin environment variables
echo "🔍 Checking admin environment variables..."
env_file="$(dirname "$0")/gearted-backend/.env"

if [ -f "$env_file" ]; then
    echo "📄 Found environment file: $env_file"
    
    # Check if file contains ADMIN_EMAIL
    if grep -q "ADMIN_EMAIL=" "$env_file"; then
        echo "✅ ADMIN_EMAIL is configured in .env file"
    else
        echo "❌ ADMIN_EMAIL is not configured"
        echo "ℹ️  Adding ADMIN_EMAIL to .env file..."
        echo "ADMIN_EMAIL=admin@gearted.com" >> "$env_file"
        echo "✅ Added ADMIN_EMAIL to .env file"
    fi
else
    echo "❌ Could not find .env file"
fi

echo "✅ Backend verification complete"
