#!/bin/bash

# Variables de couleur
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "======================================="
echo -e "Démarrage de l'environnement Gearted"
echo -e "======================================="

# Démarrer l'infrastructure (Docker)
echo -e "\nDémarrage des services Docker..."
cd gearted-infra
docker-compose up -d

if [ 0 -eq 0 ]; then
  echo -e "✓ Services Docker démarrés avec succès"
else
  echo -e "✗ Erreur lors du démarrage des services Docker"
  exit 1
fi

# Démarrer le backend
echo -e "\nDémarrage du backend..."
cd ../gearted-backend
gnome-terminal --tab --title="Gearted Backend" -- bash -c "npm run dev; read -p 'Appuyez sur Entrée pour fermer...'"

# Démarrer l'application Flutter
echo -e "\nDémarrage de l'application Flutter..."
cd ../gearted-mobile
gnome-terminal --tab --title="Gearted Mobile" -- bash -c "flutter run; read -p 'Appuyez sur Entrée pour fermer...'"

echo -e "\nEnvironnement de développement démarré!"
echo -e "======================================="
echo -e "Backend API: http://localhost:3000/api"
echo -e "Base de données: localhost:5432"
echo -e "Redis: localhost:6379"
echo -e "======================================="
