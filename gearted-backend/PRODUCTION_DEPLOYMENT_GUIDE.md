# GUIDE DE DÉPLOIEMENT PRODUCTION - SERVICE NOTIFICATION GEARTED

## 🚀 PRÉREQUIS DE DÉPLOIEMENT

### **1. Comptes de Service Requis**

#### **Firebase (Notifications Push)**
```bash
# 1. Créer un projet Firebase
# 2. Activer Firebase Cloud Messaging (FCM)
# 3. Générer une clé de service (Service Account)
# 4. Télécharger le fichier JSON des credentials

# Configuration dans .env :
FIREBASE_PROJECT_ID=gearted-production
FIREBASE_CLIENT_EMAIL=firebase-adminsdk-xxxxx@gearted-production.iam.gserviceaccount.com
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nMIIEvQ...votre_clé_complète...==\n-----END PRIVATE KEY-----"
```

#### **Gmail/SMTP (Notifications Email)**
```bash
# Option 1: Gmail avec App Password
# 1. Activer l'authentification à 2 facteurs
# 2. Générer un mot de passe d'application
EMAIL_SERVICE=gmail
EMAIL_USER=notifications@gearted.com
EMAIL_PASS=xxxx-xxxx-xxxx-xxxx  # App Password
EMAIL_FROM=Gearted <notifications@gearted.com>

# Option 2: SMTP personnalisé
EMAIL_SERVICE=smtp
EMAIL_HOST=smtp.votre-fournisseur.com
EMAIL_PORT=587
EMAIL_SECURE=true
```

#### **Twilio (Notifications SMS)**
```bash
# 1. Créer un compte Twilio
# 2. Obtenir Account SID et Auth Token
# 3. Acheter un numéro de téléphone

TWILIO_ACCOUNT_SID=ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
TWILIO_AUTH_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
TWILIO_PHONE_NUMBER=+33123456789
```

---

## 🔧 CONFIGURATION SERVEUR

### **Variables d'Environnement Production**
```bash
# Créer le fichier .env.production
cat > .env.production << 'EOF'
# ==========================================
# GEARTED BACKEND - CONFIGURATION PRODUCTION
# ==========================================

# Base de données
MONGODB_URI=mongodb+srv://gearted-prod:PASSWORD@cluster.mongodb.net/gearted-production
DB_NAME=gearted-production

# JWT et sécurité
JWT_SECRET=votre_jwt_secret_super_securise_256_bits
JWT_EXPIRES_IN=7d
BCRYPT_ROUNDS=12

# URLs de l'application
NODE_ENV=production
PORT=3000
APP_URL=https://gearted.com
API_URL=https://api.gearted.com
CLIENT_URL=https://gearted.com

# Firebase (Push Notifications)
FIREBASE_PROJECT_ID=gearted-production
FIREBASE_CLIENT_EMAIL=firebase-adminsdk-xxxxx@gearted-production.iam.gserviceaccount.com
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nMIIEvQ...VOTRE_CLÉ_PRIVÉE_COMPLÈTE...==\n-----END PRIVATE KEY-----"

# Email (Gmail)
EMAIL_SERVICE=gmail
EMAIL_USER=notifications@gearted.com
EMAIL_PASS=xxxx-xxxx-xxxx-xxxx
EMAIL_FROM=Gearted <notifications@gearted.com>

# SMS (Twilio)
TWILIO_ACCOUNT_SID=ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
TWILIO_AUTH_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
TWILIO_PHONE_NUMBER=+33123456789

# AWS S3 (Upload de fichiers)
AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
AWS_REGION=eu-west-3
AWS_BUCKET_NAME=gearted-production-uploads

# Analytics et monitoring
SENTRY_DSN=https://xxxxx@sentry.io/xxxxx
GOOGLE_ANALYTICS_ID=GA-XXXXXXXXX

# Limites et performance
RATE_LIMIT_WINDOW_MS=900000  # 15 minutes
RATE_LIMIT_MAX_REQUESTS=100
MAX_FILE_SIZE=10485760       # 10MB
MAX_FILES_PER_LISTING=6

# Redis (Cache et sessions)
REDIS_URL=redis://localhost:6379
REDIS_PASSWORD=votre_redis_password

EOF
```

### **Configuration Nginx (Proxy Reverse)**
```nginx
# /etc/nginx/sites-available/gearted-api
server {
    listen 80;
    server_name api.gearted.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name api.gearted.com;

    # SSL Configuration
    ssl_certificate /path/to/ssl/certificate.crt;
    ssl_certificate_key /path/to/ssl/private.key;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512;

    # Security headers
    add_header X-Frame-Options DENY;
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    # Upload limits
    client_max_body_size 10M;
    client_body_timeout 60s;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        
        # Timeouts
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
}
```

---

## 🐳 DÉPLOIEMENT DOCKER

### **Dockerfile Optimisé**
```dockerfile
# Dockerfile.production
FROM node:18-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

COPY . .
RUN npm run build

FROM node:18-alpine AS production

# Sécurité
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nodejs -u 1001

WORKDIR /app

# Copier les dépendances et le build
COPY --from=builder --chown=nodejs:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=nodejs:nodejs /app/dist ./dist
COPY --from=builder --chown=nodejs:nodejs /app/package*.json ./

# Santé du conteneur
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/api/health || exit 1

USER nodejs
EXPOSE 3000

CMD ["node", "dist/server.js"]
```

### **Docker Compose Production**
```yaml
# docker-compose.production.yml
version: '3.8'

services:
  gearted-api:
    build:
      context: .
      dockerfile: Dockerfile.production
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
    env_file:
      - .env.production
    volumes:
      - ./logs:/app/logs
    restart: unless-stopped
    depends_on:
      - redis
    networks:
      - gearted-network

  redis:
    image: redis:7-alpine
    command: redis-server --appendonly yes --requirepass ${REDIS_PASSWORD}
    volumes:
      - redis-data:/data
    restart: unless-stopped
    networks:
      - gearted-network

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
    restart: unless-stopped
    depends_on:
      - gearted-api
    networks:
      - gearted-network

volumes:
  redis-data:

networks:
  gearted-network:
    driver: bridge
```

---

## 📊 MONITORING ET LOGS

### **Configuration PM2 (Alternative à Docker)**
```javascript
// ecosystem.config.js
module.exports = {
  apps: [{
    name: 'gearted-api',
    script: 'dist/server.js',
    instances: 'max',
    exec_mode: 'cluster',
    env: {
      NODE_ENV: 'production',
      PORT: 3000
    },
    env_file: '.env.production',
    
    // Monitoring
    monitoring: true,
    pmx: true,
    
    // Logs
    log_file: './logs/combined.log',
    out_file: './logs/out.log',
    error_file: './logs/error.log',
    log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
    
    // Auto-restart
    watch: false,
    max_memory_restart: '1G',
    min_uptime: '10s',
    max_restarts: 10,
    
    // Graceful shutdown
    kill_timeout: 5000
  }]
};
```

### **Script de Déploiement**
```bash
#!/bin/bash
# deploy.sh

set -e

echo "🚀 Déploiement Gearted API..."

# Variables
REPO_URL="https://github.com/votre-org/gearted-backend.git"
DEPLOY_DIR="/var/www/gearted-api"
BACKUP_DIR="/var/backups/gearted-api"

# Backup de la version actuelle
if [ -d "$DEPLOY_DIR" ]; then
    echo "📦 Sauvegarde de la version actuelle..."
    sudo cp -r $DEPLOY_DIR $BACKUP_DIR/$(date +%Y%m%d_%H%M%S)
fi

# Clone/Pull du code
echo "📥 Récupération du code..."
if [ -d "$DEPLOY_DIR" ]; then
    cd $DEPLOY_DIR && git pull origin main
else
    git clone $REPO_URL $DEPLOY_DIR
    cd $DEPLOY_DIR
fi

# Installation des dépendances
echo "📦 Installation des dépendances..."
npm ci --only=production

# Build de l'application
echo "🔨 Build de l'application..."
npm run build

# Copie de la configuration
echo "⚙️  Configuration..."
sudo cp .env.production .env

# Tests de santé
echo "🧪 Tests de santé..."
npm run test:health

# Restart du service
echo "🔄 Redémarrage du service..."
pm2 reload ecosystem.config.js --env production

# Vérification du déploiement
echo "✅ Vérification du déploiement..."
sleep 5
curl -f http://localhost:3000/api/health || {
    echo "❌ Échec du déploiement - rollback..."
    pm2 stop gearted-api
    # Restaurer la sauvegarde
    exit 1
}

echo "🎉 Déploiement réussi !"
```

---

## 🔐 SÉCURITÉ PRODUCTION

### **Checklist Sécurité**
```bash
# 1. Firewall
sudo ufw enable
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443

# 2. Fail2ban
sudo apt install fail2ban
sudo systemctl enable fail2ban

# 3. SSL/TLS
# Utiliser Let's Encrypt pour les certificats gratuits
sudo certbot --nginx -d api.gearted.com

# 4. Monitoring
# Installer et configurer Datadog/New Relic/Sentry

# 5. Backup automatique
# Configurer les sauvegardes MongoDB et Redis
```

### **Variables Sensibles**
```bash
# Utiliser des gestionnaires de secrets en production
# AWS Secrets Manager, HashiCorp Vault, etc.

# Générer des secrets forts
openssl rand -hex 32  # JWT_SECRET
openssl rand -hex 16  # Autres secrets
```

---

## 🧪 TESTS DE VALIDATION

### **Script de Tests Production**
```bash
#!/bin/bash
# test-production.sh

echo "🧪 Tests de validation production..."

# Test de santé API
echo "1. Test santé API..."
curl -f https://api.gearted.com/api/health || exit 1

# Test notifications
echo "2. Test service notifications..."
node test-notifications.js || exit 1

# Test uploads
echo "3. Test service uploads..."
node test-s3-upload.js || exit 1

# Test base de données
echo "4. Test connexion base de données..."
node test-services.js || exit 1

echo "✅ Tous les tests passent !"
```

---

## 📋 CHECKLIST DE DÉPLOIEMENT

### **Avant le Déploiement**
- [ ] Variables d'environnement configurées
- [ ] Certificats SSL installés  
- [ ] Base de données MongoDB configurée
- [ ] Comptes Firebase, Gmail, Twilio créés
- [ ] Sauvegardes configurées
- [ ] Monitoring mis en place

### **Pendant le Déploiement**
- [ ] Build sans erreurs
- [ ] Tests de santé passent
- [ ] Services démarrés correctement
- [ ] Logs sans erreurs critiques

### **Après le Déploiement**
- [ ] Tests fonctionnels validés
- [ ] Notifications de test envoyées
- [ ] Performance monitoring actif
- [ ] Documentation mise à jour

---

## 🎯 RÉSULTAT FINAL

**🚀 SERVICE NOTIFICATION GEARTED PRÊT POUR LA PRODUCTION**

✅ **Configuration robuste** avec fallbacks gracieux  
✅ **Déploiement automatisé** avec Docker/PM2  
✅ **Monitoring complet** et gestion d'erreurs  
✅ **Sécurité renforcée** avec SSL et authentification  
✅ **Scalabilité** horizontale et verticale  

**Le marketplace Gearted dispose maintenant d'un système de notification professionnel !** 🎊
