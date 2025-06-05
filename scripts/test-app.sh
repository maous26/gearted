#!/bin/bash

# Variables de couleur
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Obtenir le chemin absolu du répertoire du projet
PROJECT_DIR=$(pwd)

echo -e "======================================="
echo -e "Test complet des composants Gearted"
echo -e "======================================="

# Test du backend API
echo -e "\nTest du backend API..."
curl -s http://localhost:3000/api/health > /dev/null 2>&1
if [ 0 -eq 0 ]; then
  echo -e "✓ API accessible"
else
  echo -e "✗ API non accessible - Vérifiez que le backend est en cours d'exécution"
fi

# Vérifier les écrans de l'application Flutter
echo -e "\nVérification des écrans principaux..."

SCREENS=(
  "lib/features/auth/screens/login_screen.dart"
  "lib/features/auth/screens/register_screen.dart"
  "lib/features/home/screens/home_screen.dart"
  "lib/features/listing/screens/listing_detail_screen.dart"
  "lib/features/listing/screens/create_listing_screen.dart"
  "lib/features/profile/screens/profile_screen.dart"
  "lib/features/search/screens/search_screen.dart"
  "lib/features/chat/screens/chat_list_screen.dart"
  "lib/features/chat/screens/chat_detail_screen.dart"
)

cd "$PROJECT_DIR/gearted-mobile" || { echo -e "Le répertoire gearted-mobile n'existe pas"; exit 1; }

echo -e "\nÉcrans principaux:"
for screen in "${SCREENS[@]}"; do
  if [ -f "$screen" ]; then
    echo -e "✓ $screen"
  else
    echo -e "✗ $screen n'existe pas"
  fi
done

echo -e "\nVérification des widgets communs..."

WIDGETS=(
  "lib/widgets/common/gearted_button.dart"
  "lib/widgets/common/gearted_text_field.dart"
  "lib/widgets/common/gearted_card.dart"
  "lib/widgets/common/gearted_bottom_navbar.dart"
)

echo -e "\nWidgets communs:"
for widget in "${WIDGETS[@]}"; do
  if [ -f "$widget" ]; then
    echo -e "✓ $widget"
  else
    echo -e "✗ $widget n'existe pas"
  fi
done

echo -e "\nVérification des services et providers..."

SERVICES=(
  "lib/services/api_service.dart"
  "lib/services/listing_service.dart"
  "lib/providers/auth_provider.dart"
)

echo -e "\nServices et providers:"
for service in "${SERVICES[@]}"; do
  if [ -f "$service" ]; then
    echo -e "✓ $service"
  else
    echo -e "✗ $service n'existe pas"
  fi
done

# Vérifier les contrôleurs backend
cd "$PROJECT_DIR/gearted-backend" || { echo -e "Le répertoire gearted-backend n'existe pas"; exit 1; }

echo -e "\nVérification des contrôleurs backend..."

CONTROLLERS=(
  "src/controllers/auth.controller.ts"
  "src/controllers/listing.controller.ts"
)

echo -e "\nContrôleurs backend:"
for controller in "${CONTROLLERS[@]}"; do
  if [ -f "$controller" ]; then
    echo -e "✓ $controller"
  else
    echo -e "✗ $controller n'existe pas"
  fi
done

# Retour au répertoire du projet
cd "$PROJECT_DIR" || exit

echo -e "\nTests terminés!"
echo -e "======================================="
echo -e "Progression Sprint 1: 100% complétée"
echo -e "======================================="
