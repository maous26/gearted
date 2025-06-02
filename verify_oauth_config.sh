#!/bin/bash
# Verify OAuth Configuration and Setup

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo -e "${BOLD}===============================================${NC}"
echo -e "${BOLD}      GEARTED OAUTH CONFIGURATION CHECKER      ${NC}"
echo -e "${BOLD}===============================================${NC}"

# Check if .env file exists
if [ ! -f "./gearted-mobile/.env" ]; then
  echo -e "${RED}❌ ERROR: .env file not found in gearted-mobile directory${NC}"
  echo -e "${YELLOW}Please create an .env file by copying from .env.example${NC}"
  exit 1
fi

# Extract OAuth configurations
GOOGLE_ID=$(grep "GOOGLE_WEB_CLIENT_ID" ./gearted-mobile/.env | cut -d '=' -f2)
FACEBOOK_ID=$(grep "FACEBOOK_APP_ID" ./gearted-mobile/.env | cut -d '=' -f2)

echo -e "\n${BLUE}Checking OAuth configurations...${NC}"

# Check Google OAuth config
if [[ "$GOOGLE_ID" == "your_google_web_client_id_here" || -z "$GOOGLE_ID" ]]; then
  echo -e "${RED}❌ Google Web Client ID: Not configured${NC}"
  GOOGLE_CONFIG_OK=false
else
  echo -e "${GREEN}✅ Google Web Client ID: Configured${NC}"
  GOOGLE_CONFIG_OK=true
fi

# Check Facebook OAuth config
if [[ "$FACEBOOK_ID" == "your_facebook_app_id_here" || -z "$FACEBOOK_ID" ]]; then
  echo -e "${RED}❌ Facebook App ID: Not configured${NC}"
  FACEBOOK_CONFIG_OK=false
else
  echo -e "${GREEN}✅ Facebook App ID: Configured${NC}"
  FACEBOOK_CONFIG_OK=true
fi

echo -e "\n${BLUE}Android Platform Configuration:${NC}"
# Check build.gradle for Google and Facebook dependencies
if grep -q "com.google.android.gms:play-services-auth" ./gearted-mobile/android/app/build.gradle; then
  echo -e "${GREEN}✅ Google Sign-In dependencies found${NC}"
else
  echo -e "${YELLOW}⚠️ Google Sign-In dependencies might be missing in build.gradle${NC}"
fi

if grep -q "com.facebook.android:facebook-login" ./gearted-mobile/android/app/build.gradle; then
  echo -e "${GREEN}✅ Facebook Login dependencies found${NC}"
else
  echo -e "${YELLOW}⚠️ Facebook Login dependencies might be missing in build.gradle${NC}"
fi

echo -e "\n${BLUE}iOS Platform Configuration:${NC}"
if [ -f "./gearted-mobile/ios/Runner/Info.plist" ]; then
  # Check Info.plist for Facebook configuration
  if grep -q "FacebookAppID" ./gearted-mobile/ios/Runner/Info.plist; then
    echo -e "${GREEN}✅ Facebook configuration found in Info.plist${NC}"
  else
    echo -e "${YELLOW}⚠️ Facebook configuration might be missing in Info.plist${NC}"
  fi
else
  echo -e "${YELLOW}⚠️ iOS configuration files not found${NC}"
fi

echo -e "\n${BOLD}===============================================${NC}"
echo -e "${BOLD}              SUMMARY & NEXT STEPS             ${NC}"
echo -e "${BOLD}===============================================${NC}"

if [[ "$GOOGLE_CONFIG_OK" == "true" && "$FACEBOOK_CONFIG_OK" == "true" ]]; then
  echo -e "${GREEN}✅ OAuth configuration appears to be complete.${NC}"
  echo -e "${GREEN}   You should be able to use Google and Facebook login.${NC}"
else
  echo -e "${YELLOW}⚠️ OAuth configuration is incomplete.${NC}"
  echo -e "${YELLOW}   Please follow these steps:${NC}"
  
  if [[ "$GOOGLE_CONFIG_OK" == "false" ]]; then
    echo -e "   ${BOLD}Google OAuth:${NC}"
    echo -e "   1. Go to ${BLUE}https://console.cloud.google.com/${NC}"
    echo -e "   2. Create a project or select an existing one"
    echo -e "   3. Enable the Google+ API"
    echo -e "   4. Create OAuth credentials (Web client)"
    echo -e "   5. Update GOOGLE_WEB_CLIENT_ID in your .env file"
  fi
  
  if [[ "$FACEBOOK_CONFIG_OK" == "false" ]]; then
    echo -e "   ${BOLD}Facebook OAuth:${NC}"
    echo -e "   1. Go to ${BLUE}https://developers.facebook.com/${NC}"
    echo -e "   2. Create a new app or select an existing one"
    echo -e "   3. Add Facebook Login product"
    echo -e "   4. Set up OAuth redirect URIs"
    echo -e "   5. Update FACEBOOK_APP_ID in your .env file"
  fi
fi

echo -e "\n${BOLD}For detailed setup instructions, refer to:${NC}"
echo -e "${BLUE}/Users/moussa/gearted/OAUTH_SETUP_GUIDE.md${NC}"
echo -e "${BOLD}===============================================${NC}"
