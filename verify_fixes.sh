#!/bin/zsh

# Test script for Gearted fixes
# This script will verify all the fixes we've made

# Set colors for better readability
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color

echo "${BLUE}===== GEARTED FIXES VERIFICATION SCRIPT =====${NC}"
echo

# 1. Test backend port handling
echo "${YELLOW}1. Testing backend port cleanup...${NC}"
echo "Starting backend server..."

cd /Users/moussa/gearted/gearted-backend
PORT_CHECK=$(lsof -i:3000 | grep LISTEN)

if [ -n "$PORT_CHECK" ]; then
  echo "Process found on port 3000. Killing it before server start..."
  npx kill-port 3000
fi

# Start server in background
npm run dev > /dev/null 2>&1 &
SERVER_PID=$!

# Wait for server to start
sleep 3

# Check if server is running
if curl -s http://localhost:3000/api/health > /dev/null; then
  echo "${GREEN}✓ Backend server started successfully on port 3000${NC}"
else
  echo "${RED}✗ Backend server failed to start${NC}"
fi

echo

# 2. Test JWT token expiration
echo "${YELLOW}2. Testing JWT token generation and validation...${NC}"

# Create a new user or login
TOKEN_RESPONSE=$(curl -s -X POST http://localhost:3000/api/auth/login -H "Content-Type: application/json" -d '{"email": "testuser@example.com", "password": "testpass123"}')

# Extract token from response
TOKEN=$(echo $TOKEN_RESPONSE | grep -o '"token":"[^"]*"' | cut -d'"' -f4)

if [ -z "$TOKEN" ]; then
  echo "${RED}✗ Failed to get token${NC}"
else
  echo "${GREEN}✓ Successfully generated token${NC}"
  
  # Check token validity
  VERIFY_RESPONSE=$(curl -s -X GET http://localhost:3000/api/auth/me -H "Authorization: Bearer $TOKEN")
  
  if echo $VERIFY_RESPONSE | grep -q '"success":true'; then
    echo "${GREEN}✓ Token authentication successful${NC}"
    
    # Decode token to verify expiration
    echo "Decoding token to check expiration..."
    node -e "
      const jwt = '$TOKEN';
      const decoded = JSON.parse(Buffer.from(jwt.split('.')[1], 'base64').toString());
      const expires = new Date(decoded.exp * 1000);
      const duration = (decoded.exp - decoded.iat) / 3600;
      console.log('Token expires: ' + expires);
      console.log('Duration: ' + duration + ' hours');
      
      if (Math.abs(duration - 24) < 0.1) {
        console.log('${GREEN}✓ Token has correct 24-hour expiration${NC}');
      } else {
        console.log('${RED}✗ Token expiration is not 24 hours${NC}');
      }
    "
  else
    echo "${RED}✗ Token authentication failed${NC}"
  fi
fi

echo

# 3. Verify Image Picker integration
echo "${YELLOW}3. Checking Image Picker integration...${NC}"

# Check pubspec.yaml for image_picker dependency
if grep -q "image_picker:" /Users/moussa/gearted/gearted-mobile/pubspec.yaml; then
  echo "${GREEN}✓ Image picker dependency found in pubspec.yaml${NC}"
else
  echo "${RED}✗ Image picker dependency not found in pubspec.yaml${NC}"
fi

# Check if ImagePicker is imported and used correctly
if grep -q "import 'package:image_picker/image_picker.dart';" /Users/moussa/gearted/gearted-mobile/lib/features/listing/screens/create_listing_screen.dart; then
  echo "${GREEN}✓ Image picker import found in create_listing_screen.dart${NC}"
else
  echo "${RED}✗ Image picker import not found in create_listing_screen.dart${NC}"
fi

# Check for actual implementation
if grep -q "ImagePicker picker = ImagePicker()" /Users/moussa/gearted/gearted-mobile/lib/features/listing/screens/create_listing_screen.dart; then
  echo "${GREEN}✓ Image picker implementation found${NC}"
else
  if grep -q "final ImagePicker picker = ImagePicker();" /Users/moussa/gearted/gearted-mobile/lib/features/listing/screens/create_listing_screen.dart; then
    echo "${GREEN}✓ Image picker implementation found${NC}"
  else
    echo "${RED}✗ Image picker implementation not found${NC}"
  fi
fi

echo

# 4. Test Auth Service enhancements
echo "${YELLOW}4. Verifying AuthService enhancements...${NC}"

# Check for token debug utility
if [ -f "/Users/moussa/gearted/gearted-mobile/token_debug.dart" ]; then
  echo "${GREEN}✓ Token debug utility exists${NC}"
else
  echo "${RED}✗ Token debug utility not found${NC}"
fi

# Check for improved token validation
if grep -q "_isValidTokenFormat" /Users/moussa/gearted/gearted-mobile/lib/services/auth_service.dart; then
  echo "${GREEN}✓ Enhanced token validation found in AuthService${NC}"
else
  echo "${RED}✗ Enhanced token validation not found in AuthService${NC}"
fi

# Check for refreshToken method
if grep -q "refreshToken()" /Users/moussa/gearted/gearted-mobile/lib/services/auth_service.dart; then
  echo "${GREEN}✓ Token refresh functionality found${NC}"
else
  echo "${RED}✗ Token refresh functionality not found${NC}"
fi

echo

# Clean up resources
echo "${YELLOW}Cleaning up...${NC}"
echo "Stopping backend server (PID: $SERVER_PID)"
kill $SERVER_PID

echo
echo "${BLUE}===== VERIFICATION COMPLETE =====${NC}"
echo "See detailed reports in the following files:"
echo "- /Users/moussa/gearted/AUTH_ISSUES_RESOLUTION_SUMMARY.md"
echo "- /Users/moussa/gearted/COMPREHENSIVE_FIXES_SUMMARY.md"
