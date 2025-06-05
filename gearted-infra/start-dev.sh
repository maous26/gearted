#!/bin/bash
echo "Démarrage de l'environnement de développement Gearted..."
docker-compose up -d
echo "Services démarrés:"
echo "- PostgreSQL: localhost:5432"
echo "- Redis: localhost:6379"
echo "- API: localhost:3000"
