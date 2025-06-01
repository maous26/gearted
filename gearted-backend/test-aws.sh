#!/bin/bash
# Charger les variables depuis .env
if [ -f .env ]; then
    # Lire le fichier .env et exporter les variables AWS
    export AWS_ACCESS_KEY_ID=$(grep AWS_ACCESS_KEY .env | cut -d '=' -f2)
    export AWS_SECRET_ACCESS_KEY=$(grep AWS_SECRET_KEY .env | cut -d '=' -f2)
    export AWS_DEFAULT_REGION=$(grep AWS_REGION .env | cut -d '=' -f2 || echo "eu-west-3")
    
    echo "Variables AWS chargées depuis .env"
    
    # Tester la connexion
    echo "Test de connexion S3..."
    aws s3 ls
else
    echo "Fichier .env introuvable!"
fi
