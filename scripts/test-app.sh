#!/bin/bash

# Variables de couleur
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "======================================="
echo -e "Test des composants Gearted"
echo -e "======================================="

# Test du backend API
echo -e "\nTest du backend API..."
curl -s http://localhost:3000/api/auth/me > /dev/null
if [ 0 -eq 0 ]; then
  echo -e "✓ API accessible"
else
  echo -e "✗ API non accessible"
fi

# Vérifier les écrans de l'application Flutter
echo -e "\nVérification des fichiers de l'application mobile..."

SCREENS=(
  "gearted-mobile/lib/features/auth/screens/login_screen.dart"
  "gearted-mobile/lib/features/auth/screens/register_screen.dart"
  "gearted-mobile/lib/features/home/screens/home_screen.dart"
  "gearted-mobile/lib/features/listing/screens/listing_detail_screen.dart"
  "gearted-mobile/lib/features/profile/screens/profile_screen.dart"
  "gearted-mobile/lib/features/search/screens/search_screen.dart"
)

for screen in ""; do
  if [ -f "" ]; then
    echo -e "✓ "
  else
    echo -e "✗  n'existe pas"
  fi
done

echo -e "\nVérification des widgets communs..."

WIDGETS=(
  "gearted-mobile/lib/widgets/common/gearted_button.dart"
  "gearted-mobile/lib/widgets/common/gearted_text_field.dart"
  "gearted-mobile/lib/widgets/common/gearted_card.dart"
  "gearted-mobile/lib/widgets/common/gearted_bottom_navbar.dart"
)

for widget in ""; do
  if [ -f "" ]; then
    echo -e "✓ "
  else
    echo -e "✗  n'existe pas"
  fi
done

echo -e "\nTests terminés!"
echo -e "======================================="
echo -e "Progression Sprint 1: 75% complétée"
echo -e "======================================="
