#!/bin/bash

# Supprimer l'ancienne configuration
rm -rf ~/.aws
mkdir -p ~/.aws

# Extraire les credentials depuis .env
if [ -f .env ]; then
    ACCESS_KEY=$(grep "AWS_ACCESS_KEY=" .env | head -1 | cut -d '=' -f2- | sed 's/^ *//;s/ *$//' | tr -d '"')
    SECRET_KEY=$(grep "AWS_SECRET_KEY=" .env | cut -d '=' -f2- | sed 's/^ *//;s/ *$//' | tr -d '"')
    
    # Créer le fichier credentials
    cat > ~/.aws/credentials << EOL
[default]
aws_access_key_id = ${ACCESS_KEY}
aws_secret_access_key = ${SECRET_KEY}
EOL

    # Créer le fichier config
    cat > ~/.aws/config << EOL
[default]
region = eu-north-1
output = json
EOL

    # Définir les bonnes permissions
    chmod 600 ~/.aws/credentials
    chmod 600 ~/.aws/config
    
    echo "Configuration AWS réparée!"
    echo "Test de connexion..."
    aws s3 ls
    
    echo -e "\nContenu du bucket gearted-images:"
    aws s3 ls s3://gearted-images/
else
    echo "Fichier .env non trouvé!"
fi
