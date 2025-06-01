#!/bin/bash

# Charger les credentials depuis .env
if [ -f .env ]; then
    echo "Chargement des credentials AWS depuis .env..."
    
    # Extraire les valeurs
    ACCESS_KEY=$(grep "AWS_ACCESS_KEY=" .env | head -1 | cut -d '=' -f2- | tr -d ' ' | tr -d '"')
    SECRET_KEY=$(grep "AWS_SECRET_KEY=" .env | cut -d '=' -f2- | tr -d ' ' | tr -d '"')
    
    # Configurer AWS CLI
    aws configure set aws_access_key_id "$ACCESS_KEY"
    aws configure set aws_secret_access_key "$SECRET_KEY"
    aws configure set region eu-north-1
    
    echo "AWS CLI configuré avec succès!"
    echo "Test de connexion..."
    aws s3 ls
else
    echo "Fichier .env non trouvé!"
fi
