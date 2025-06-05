# Guide d'installation Gearted

## Prérequis
- Flutter SDK (3.0.0 ou supérieur)
- Node.js (18.x ou supérieur)
- Docker et Docker Compose
- Git

## Installation du projet

### 1. Cloner le repository
```bash
git clone https://github.com/gearted/gearted.git
cd gearted
```

### 2. Configuration de l'environnement mobile
```bash
cd gearted-mobile
flutter pub get
```

Créez un fichier `.env` à partir du fichier `.env.example`.

### 3. Configuration de l'environnement backend
```bash
cd ../gearted-backend
npm install
```

Créez un fichier `.env` à partir du fichier `.env.example`.

### 4. Lancement de l'environnement de développement
```bash
cd ../gearted-infra
./start-dev.sh
```

### 5. Exécution de l'application mobile
```bash
cd ../gearted-mobile
flutter run
```

## Structure des branches
- `main`: Version stable en production
- `develop`: Branche de développement principal
- `staging`: Branche pour les tests de pré-production
- `feature/*`: Branches de fonctionnalités

## Workflow de développement
1. Créer une branche de feature à partir de `develop`
2. Implémenter la fonctionnalité
3. Faire une Pull Request vers `develop`
4. Après validation, merger dans `develop`
5. À chaque sprint, merger `develop` dans `staging` pour les tests
6. Si tout est OK, merger `staging` dans `main` pour le déploiement en production
