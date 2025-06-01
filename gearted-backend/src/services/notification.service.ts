import * as admin from 'firebase-admin';
import * as nodemailer from 'nodemailer';
import { logger } from '../utils/logger';
import analyticsService from './analytics.service';
import User, { IUser } from '../models/user.model';

// Initialiser Firebase Admin si pas déjà fait et si les credentials sont disponibles
let firebaseInitialized = false;
try {
  if (!admin.apps.length && process.env.FIREBASE_PROJECT_ID && process.env.FIREBASE_PRIVATE_KEY) {
    admin.initializeApp({
      credential: admin.credential.cert({
        projectId: process.env.FIREBASE_PROJECT_ID,
        clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
        privateKey: process.env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, '\n')
      }),
    });
    firebaseInitialized = true;
    logger.info('Firebase Admin initialized successfully');
  } else {
    logger.warn('Firebase not initialized - missing credentials');
  }
} catch (error) {
  logger.warn(`Firebase initialization skipped: ${error instanceof Error ? error.message : String(error)}`);
  firebaseInitialized = false;
}

// Configuration email avec gestion d'erreurs améliorée
let emailTransporter: nodemailer.Transporter | null = null;
try {
  if (process.env.EMAIL_USER && process.env.EMAIL_PASS) {
    emailTransporter = nodemailer.createTransport({
      service: process.env.EMAIL_SERVICE || 'gmail',
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS
      },
      secure: true,
      tls: {
        rejectUnauthorized: false
      }
    });
    logger.info('Email transporter initialized successfully');
  } else {
    logger.warn('Email not configured - missing EMAIL_USER or EMAIL_PASS');
  }
} catch (error) {
  logger.warn(`Email transporter initialization failed: ${error instanceof Error ? error.message : String(error)}`);
}

// Types de notifications étendus
export enum NotificationType {
  // Messages et communication
  NEW_MESSAGE = 'new_message',
  MESSAGE_REPLIED = 'message_replied',
  CONVERSATION_STARTED = 'conversation_started',
  
  // Transactions et offres
  NEW_OFFER = 'new_offer',
  OFFER_ACCEPTED = 'offer_accepted',
  OFFER_DECLINED = 'offer_declined',
  OFFER_COUNTER = 'offer_counter',
  
  // Annonces
  LISTING_SOLD = 'listing_sold',
  LISTING_EXPIRED = 'listing_expired',
  LISTING_FAVORITED = 'listing_favorited',
  LISTING_PRICE_DROP = 'listing_price_drop',
  SIMILAR_LISTING_POSTED = 'similar_listing_posted',
  
  // Évaluations et feedback
  NEW_REVIEW = 'new_review',
  REVIEW_REMINDER = 'review_reminder',
  
  // Système et promotions
  WELCOME = 'welcome',
  ACCOUNT_VERIFIED = 'account_verified',
  PASSWORD_RESET = 'password_reset',
  PROMOTIONAL = 'promotional',
  SECURITY_ALERT = 'security_alert',
  
  // OAuth spécifique
  OAUTH_ACCOUNT_LINKED = 'oauth_account_linked',
  OAUTH_LOGIN_SUCCESS = 'oauth_login_success',
  ACCOUNT_MERGE_REQUIRED = 'account_merge_required',
  NEW_OAUTH_PROVIDER_ADDED = 'new_oauth_provider_added',
  
  // Marketplace
  CATEGORY_UPDATE = 'category_update',
  WEEKLY_DIGEST = 'weekly_digest',
  ABANDONED_CART = 'abandoned_cart'
}

// Priorités des notifications
export enum NotificationPriority {
  LOW = 'low',
  NORMAL = 'normal',
  HIGH = 'high',
  URGENT = 'urgent'
}

// Canaux de notification
export enum NotificationChannel {
  PUSH = 'push',
  EMAIL = 'email',
  SMS = 'sms',
  IN_APP = 'in_app'
}

// Interface pour les notifications
export interface NotificationRequest {
  userId: string;
  type: NotificationType;
  title: string;
  body: string;
  priority: NotificationPriority;
  channels: NotificationChannel[];
  data?: Record<string, any>;
  templateId?: string;
  templateData?: Record<string, any>;
  scheduledFor?: Date;
  expiresAt?: Date;
}

// Interface pour les préférences utilisateur
export interface UserNotificationPreferences {
  userId: string;
  pushEnabled: boolean;
  emailEnabled: boolean;
  smsEnabled: boolean;
  types: Partial<Record<NotificationType, boolean>>;
  quietHours?: {
    start: string; // "22:00"
    end: string;   // "08:00"
    timezone: string;
  };
  frequency: 'immediate' | 'daily_digest' | 'weekly_digest';
}

// Templates de notifications (partial pour éviter les erreurs d'index)
const NOTIFICATION_TEMPLATES: Partial<Record<NotificationType, {
  title: string;
  body: string;
  email?: {
    subject: string;
    html: string;
  };
}>> = {
  [NotificationType.NEW_MESSAGE]: {
    title: 'Nouveau message de {senderName}',
    body: '{senderName} vous a envoyé un message concernant {listingTitle}',
    email: {
      subject: 'Nouveau message sur Gearted',
      html: `
        <h2>Nouveau message reçu</h2>
        <p>Bonjour {userName},</p>
        <p><strong>{senderName}</strong> vous a envoyé un message concernant votre annonce <strong>{listingTitle}</strong>.</p>
        <p>Message: "{messagePreview}"</p>
        <a href="{chatUrl}" style="background: #007bff; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;">Voir le message</a>
      `
    }
  },
  [NotificationType.NEW_OFFER]: {
    title: 'Nouvelle offre de {buyerName}',
    body: 'Offre de {amount}€ pour {listingTitle}',
    email: {
      subject: 'Nouvelle offre sur votre annonce',
      html: `
        <h2>Nouvelle offre reçue</h2>
        <p>Bonjour {userName},</p>
        <p><strong>{buyerName}</strong> a fait une offre de <strong>{amount}€</strong> pour votre annonce <strong>{listingTitle}</strong>.</p>
        <a href="{offerUrl}" style="background: #28a745; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;">Voir l'offre</a>
      `
    }
  },
  [NotificationType.LISTING_SOLD]: {
    title: 'Félicitations ! {listingTitle} a été vendu',
    body: 'Votre annonce a été vendue pour {amount}€',
    email: {
      subject: 'Vente confirmée sur Gearted',
      html: `
        <h2>Félicitations pour votre vente !</h2>
        <p>Bonjour {userName},</p>
        <p>Votre annonce <strong>{listingTitle}</strong> a été vendue pour <strong>{amount}€</strong>.</p>
        <p>N'oubliez pas de laisser un avis sur l'acheteur !</p>
        <a href="{reviewUrl}" style="background: #ffc107; color: black; padding: 10px 20px; text-decoration: none; border-radius: 5px;">Laisser un avis</a>
      `
    }
  },
  [NotificationType.WELCOME]: {
    title: 'Bienvenue sur Gearted !',
    body: 'Découvrez le marketplace #1 pour les passionnés d\'airsoft',
    email: {
      subject: 'Bienvenue sur Gearted - Votre nouveau marketplace airsoft',
      html: `
        <h2>Bienvenue sur Gearted !</h2>
        <p>Bonjour {userName},</p>
        <p>Nous sommes ravis de vous accueillir sur Gearted, le marketplace dédié aux passionnés d'airsoft.</p>
        <h3>Pour commencer :</h3>
        <ul>
          <li>✅ Complétez votre profil</li>
          <li>📝 Publiez votre première annonce</li>
          <li>🔍 Explorez les catégories</li>
          <li>💬 Contactez des vendeurs</li>
        </ul>
        <a href="{appUrl}" style="background: #007bff; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;">Commencer</a>
      `
    }
  },
  [NotificationType.OAUTH_LOGIN_SUCCESS]: {
    title: 'Connexion {provider} réussie',
    body: 'Vous êtes maintenant connecté avec {provider}',
    email: {
      subject: 'Connexion {provider} confirmée sur Gearted',
      html: `
        <h2>Connexion {provider} réussie</h2>
        <p>Bonjour {userName},</p>
        <p>Votre compte Gearted a été connecté avec succès via <strong>{provider}</strong>.</p>
        <p>Date et heure: {loginTime}</p>
        <p>Appareil: {deviceInfo}</p>
        <p>Si ce n'était pas vous, veuillez nous contacter immédiatement.</p>
        <a href="{securityUrl}" style="background: #dc3545; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;">Vérifier la sécurité</a>
      `
    }
  },
  [NotificationType.OAUTH_ACCOUNT_LINKED]: {
    title: 'Compte {provider} associé',
    body: 'Votre compte {provider} a été associé avec succès',
    email: {
      subject: 'Compte {provider} associé à votre profil Gearted',
      html: `
        <h2>Compte {provider} associé</h2>
        <p>Bonjour {userName},</p>
        <p>Votre compte <strong>{provider}</strong> a été associé avec succès à votre profil Gearted.</p>
        <p>Vous pouvez maintenant vous connecter avec:</p>
        <ul>
          <li>📧 Email et mot de passe</li>
          <li>🔗 {provider}</li>
        </ul>
        <a href="{profileUrl}" style="background: #28a745; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;">Voir mon profil</a>
      `
    }
  },
  [NotificationType.ACCOUNT_MERGE_REQUIRED]: {
    title: 'Fusion de comptes requise',
    body: 'Un compte existe déjà avec cet email',
    email: {
      subject: 'Fusion de comptes Gearted requise',
      html: `
        <h2>Fusion de comptes requise</h2>
        <p>Bonjour {userName},</p>
        <p>Nous avons détecté qu'un compte existe déjà avec l'adresse email <strong>{email}</strong>.</p>
        <p>Votre compte existant utilise: <strong>{existingProvider}</strong></p>
        <p>Pour associer votre compte {provider}, veuillez vous connecter avec votre {existingProvider}, puis associer {provider} dans vos paramètres.</p>
        <a href="{loginUrl}" style="background: #007bff; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;">Se connecter</a>
      `
    }
  },
  [NotificationType.NEW_OAUTH_PROVIDER_ADDED]: {
    title: '{newProvider} ajouté à votre compte',
    body: 'Vous pouvez maintenant vous connecter avec {newProvider}',
    email: {
      subject: 'Nouveau fournisseur de connexion ajouté - Gearted',
      html: `
        <h2>Nouveau fournisseur de connexion ajouté</h2>
        <p>Bonjour {userName},</p>
        <p><strong>{newProvider}</strong> a été ajouté avec succès à votre compte Gearted.</p>
        <p>Vous pouvez maintenant vous connecter avec:</p>
        <ul>
          <li>📧 {existingProviders}</li>
          <li>✨ {newProvider}</li>
        </ul>
        <p>Gérez vos méthodes de connexion dans vos paramètres.</p>
        <a href="{settingsUrl}" style="background: #28a745; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;">Gérer les connexions</a>
      `
    }
  },
  [NotificationType.ACCOUNT_VERIFIED]: {
    title: 'Compte vérifié avec succès',
    body: 'Votre email a été vérifié automatiquement',
    email: {
      subject: 'Email vérifié - Gearted',
      html: `
        <h2>Email vérifié avec succès</h2>
        <p>Bonjour {userName},</p>
        <p>Votre adresse email a été vérifiée automatiquement via <strong>{provider}</strong>.</p>
        <p>Méthode de vérification: {verificationMethod}</p>
        <p>Votre compte est maintenant entièrement activé et prêt à utiliser.</p>
        <a href="{profileUrl}" style="background: #28a745; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;">Voir mon profil</a>
      `
    }
  },
  [NotificationType.SECURITY_ALERT]: {
    title: 'Alerte de sécurité',
    body: 'Activité suspecte détectée sur votre compte',
    email: {
      subject: 'Alerte de sécurité - Gearted',
      html: `
        <h2>⚠️ Alerte de sécurité</h2>
        <p>Bonjour {userName},</p>
        <p><strong>{alertMessage}</strong></p>
        <p>Fournisseur: {provider}</p>
        <p>Date et heure: {timestamp}</p>
        <p>Détails: {details}</p>
        <p>Si ce n'était pas vous, veuillez sécuriser votre compte immédiatement.</p>
        <a href="{securityUrl}" style="background: #dc3545; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;">Sécuriser mon compte</a>
      `
    }
  }
};

class NotificationService {
  private static instance: NotificationService;

  private constructor() {}

  public static getInstance(): NotificationService {
    if (!NotificationService.instance) {
      NotificationService.instance = new NotificationService();
    }
    return NotificationService.instance;
  }

  /**
   * Envoyer une notification
   */
  async sendNotification(request: NotificationRequest): Promise<void> {
    try {
      // Vérifier les préférences utilisateur
      const preferences = await this.getUserPreferences(request.userId);
      if (!this.shouldSendNotification(request, preferences)) {
        logger.info(`Notification ignorée pour l'utilisateur ${request.userId} selon ses préférences`);
        return;
      }

      // Enrichir avec le template si nécessaire
      const enrichedRequest = this.enrichWithTemplate(request);

      // Envoyer selon les canaux demandés
      const promises = [];
      
      if (enrichedRequest.channels.includes(NotificationChannel.PUSH) && preferences.pushEnabled) {
        promises.push(this.sendPushNotification(enrichedRequest));
      }
      
      if (enrichedRequest.channels.includes(NotificationChannel.EMAIL) && preferences.emailEnabled) {
        promises.push(this.sendEmailNotification(enrichedRequest));
      }
      
      if (enrichedRequest.channels.includes(NotificationChannel.SMS) && preferences.smsEnabled) {
        promises.push(this.sendSMSNotification(enrichedRequest));
      }
      
      if (enrichedRequest.channels.includes(NotificationChannel.IN_APP)) {
        promises.push(this.saveInAppNotification(enrichedRequest));
      }

      await Promise.allSettled(promises);

      // Tracker l'événement d'envoi
      await analyticsService.trackEvent({
        eventType: 'notification_sent' as any,
        userId: request.userId,
        timestamp: new Date(),
        properties: {
          notification_type: request.type,
          priority: request.priority,
          channels: enrichedRequest.channels,
          template_used: !!request.templateId
        }
      });

      logger.info(`Notification envoyée avec succès pour l'utilisateur ${request.userId}`);

    } catch (error) {
      logger.error(`Erreur lors de l'envoi de notification pour ${request.userId}: ${error instanceof Error ? error.message : String(error)}`);
      throw error;
    }
  }

  /**
   * Envoyer une notification push via Firebase
   */
  private async sendPushNotification(request: NotificationRequest): Promise<void> {
    try {
      if (!firebaseInitialized) {
        logger.warn(`Push notification skipped - Firebase not initialized: ${request.type} to ${request.userId}`);
        return;
      }

      // Récupérer le token FCM de l'utilisateur (depuis la base de données)
      const fcmToken = await this.getUserFCMToken(request.userId);
      if (!fcmToken) {
        logger.warn(`Aucun token FCM trouvé pour l'utilisateur ${request.userId}`);
        return;
      }

      const message = {
        notification: {
          title: request.title,
          body: request.body
        },
        data: {
          type: request.type,
          priority: request.priority,
          ...request.data
        },
        android: {
          priority: (request.priority === NotificationPriority.URGENT ? 'high' : 'normal') as 'high' | 'normal',
          notification: {
            sound: 'default',
            clickAction: 'FLUTTER_NOTIFICATION_CLICK'
          }
        },
        apns: {
          payload: {
            aps: {
              sound: 'default',
              badge: 1
            }
          }
        },
        token: fcmToken
      };

      await admin.messaging().send(message);
      
      // Tracker l'ouverture si l'utilisateur clique
      await analyticsService.trackEvent({
        eventType: 'push_notification_sent' as any,
        userId: request.userId,
        timestamp: new Date(),
        properties: {
          notification_type: request.type,
          fcm_token_exists: true
        }
      });

    } catch (error) {
      logger.error(`Erreur push notification pour ${request.userId}: ${error instanceof Error ? error.message : String(error)}`);
      throw error;
    }
  }

  /**
   * Envoyer une notification email
   */
  private async sendEmailNotification(request: NotificationRequest): Promise<void> {
    try {
      if (!emailTransporter) {
        logger.warn(`Email notification skipped - transporter not initialized: ${request.type} to ${request.userId}`);
        return;
      }

      const user = await this.getUserEmail(request.userId);
      if (!user?.email) {
        logger.warn(`Aucun email trouvé pour l'utilisateur ${request.userId}`);
        return;
      }

      const template = NOTIFICATION_TEMPLATES[request.type];
      if (!template?.email) {
        logger.warn(`Aucun template email pour le type ${request.type}`);
        return;
      }

      // Remplacer les variables dans le template
      let htmlContent = template.email.html;
      let subject = template.email.subject;

      if (request.templateData) {
        Object.entries(request.templateData).forEach(([key, value]) => {
          const regex = new RegExp(`{${key}}`, 'g');
          htmlContent = htmlContent.replace(regex, String(value));
          subject = subject.replace(regex, String(value));
        });
      }

      const mailOptions = {
        from: process.env.EMAIL_FROM || 'notifications@gearted.com',
        to: user.email,
        subject,
        html: htmlContent
      };

      await emailTransporter.sendMail(mailOptions);

      // Tracker l'envoi d'email
      await analyticsService.trackEvent({
        eventType: 'email_sent' as any,
        userId: request.userId,
        timestamp: new Date(),
        properties: {
          notification_type: request.type,
          email: user.email
        }
      });

    } catch (error) {
      logger.error(`Erreur email notification pour ${request.userId}: ${error instanceof Error ? error.message : String(error)}`);
      throw error;
    }
  }

  /**
   * Envoyer une notification SMS (placeholder - nécessite un service SMS)
   */
  private async sendSMSNotification(request: NotificationRequest): Promise<void> {
    try {
      // Implémentation avec Twilio, AWS SNS, ou autre service SMS
      logger.info(`SMS notification envoyée à ${request.userId}: ${request.body}`);
    } catch (error) {
      logger.error(`Erreur SMS notification pour ${request.userId}: ${error instanceof Error ? error.message : String(error)}`);
    }
  }

  /**
   * Sauvegarder notification in-app
   */
  private async saveInAppNotification(request: NotificationRequest): Promise<void> {
    try {
      // Sauvegarder en base de données pour l'affichage in-app
      const notification = {
        userId: request.userId,
        type: request.type,
        title: request.title,
        body: request.body,
        data: request.data,
        priority: request.priority,
        read: false,
        createdAt: new Date(),
        expiresAt: request.expiresAt
      };

      // await NotificationModel.create(notification);
      logger.info(`Notification in-app sauvegardée pour ${request.userId}`);
    } catch (error) {
      logger.error(`Erreur sauvegarde notification in-app pour ${request.userId}: ${error instanceof Error ? error.message : String(error)}`);
    }
  }

  /**
   * Enrichir la notification avec un template
   */
  private enrichWithTemplate(request: NotificationRequest): NotificationRequest {
    const template = NOTIFICATION_TEMPLATES[request.type];
    if (!request.templateId || !template) {
      return request;
    }

    let title = template.title;
    let body = template.body;

    // Remplacer les variables
    if (request.templateData) {
      Object.entries(request.templateData).forEach(([key, value]) => {
        const regex = new RegExp(`{${key}}`, 'g');
        title = title.replace(regex, String(value));
        body = body.replace(regex, String(value));
      });
    }

    return {
      ...request,
      title,
      body
    };
  }

  /**
   * Vérifier si une notification doit être envoyée selon les préférences
   */
  private shouldSendNotification(
    request: NotificationRequest, 
    preferences: UserNotificationPreferences
  ): boolean {
    // Vérifier si le type de notification est activé
    const typeEnabled = preferences.types[request.type];
    if (typeEnabled === false) {
      return false;
    }

    // Vérifier les heures silencieuses
    if (preferences.quietHours) {
      const now = new Date();
      const currentHour = now.getHours();
      const quietStart = parseInt(preferences.quietHours.start.split(':')[0]);
      const quietEnd = parseInt(preferences.quietHours.end.split(':')[0]);
      
      if (request.priority !== NotificationPriority.URGENT) {
        if (quietStart > quietEnd) {
          // Heures silencieuses traversent minuit
          if (currentHour >= quietStart || currentHour < quietEnd) {
            return false;
          }
        } else {
          // Heures silencieuses dans la même journée
          if (currentHour >= quietStart && currentHour < quietEnd) {
            return false;
          }
        }
      }
    }

    return true;
  }

  /**
   * Récupérer les préférences utilisateur
   */
  private async getUserPreferences(userId: string): Promise<UserNotificationPreferences> {
    try {
      // Récupérer depuis la base de données
      // const preferences = await UserPreferencesModel.findOne({ userId });
      
      // Valeurs par défaut
      return {
        userId,
        pushEnabled: true,
        emailEnabled: true,
        smsEnabled: false,
        types: {
          [NotificationType.NEW_MESSAGE]: true,
          [NotificationType.NEW_OFFER]: true,
          [NotificationType.LISTING_SOLD]: true,
          [NotificationType.NEW_REVIEW]: true,
          [NotificationType.WELCOME]: true,
          [NotificationType.PROMOTIONAL]: false
        },
        frequency: 'immediate'
      };
    } catch (error) {
      logger.error(`Erreur récupération préférences pour ${userId}: ${error instanceof Error ? error.message : String(error)}`);
      // Retourner des préférences par défaut en cas d'erreur
      return {
        userId,
        pushEnabled: true,
        emailEnabled: true,
        smsEnabled: false,
        types: {},
        frequency: 'immediate'
      };
    }
  }

  /**
   * Récupérer le token FCM d'un utilisateur
   */
  private async getUserFCMToken(userId: string): Promise<string | null> {
    try {
      // Récupérer depuis la base de données
      const user = await User.findById(userId).select('fcmToken');
      return user?.fcmToken || null;
      
      // Fallback pour la démo si aucun token
      // return `demo_fcm_token_${userId}`;
    } catch (error) {
      logger.error(`Erreur récupération token FCM pour ${userId}: ${error instanceof Error ? error.message : String(error)}`);
      return null;
    }
  }

  /**
   * Récupérer l'email d'un utilisateur
   */
  private async getUserEmail(userId: string): Promise<{ email: string } | null> {
    try {
      // Récupérer depuis la base de données
      const user = await User.findById(userId).select('email');
      return user ? { email: user.email } : null;
      
      // Fallback pour la démo
      // return { email: `user${userId}@example.com` };
    } catch (error) {
      logger.error(`Erreur récupération email pour ${userId}: ${error instanceof Error ? error.message : String(error)}`);
      return null;
    }
  }

  /**
   * Envoyer une notification de bienvenue
   */
  async sendWelcomeNotification(userId: string, userName: string): Promise<void> {
    await this.sendNotification({
      userId,
      type: NotificationType.WELCOME,
      title: 'Bienvenue sur Gearted !',
      body: 'Découvrez le marketplace #1 pour les passionnés d\'airsoft',
      priority: NotificationPriority.NORMAL,
      channels: [NotificationChannel.PUSH, NotificationChannel.EMAIL, NotificationChannel.IN_APP],
      templateData: {
        userName,
        appUrl: process.env.APP_URL || 'https://gearted.com'
      }
    });
  }

  /**
   * Envoyer une notification de nouveau message
   */
  async sendNewMessageNotification(
    userId: string, 
    senderName: string, 
    listingTitle: string,
    messagePreview: string,
    chatUrl: string
  ): Promise<void> {
    await this.sendNotification({
      userId,
      type: NotificationType.NEW_MESSAGE,
      title: `Nouveau message de ${senderName}`,
      body: `${senderName} vous a envoyé un message concernant ${listingTitle}`,
      priority: NotificationPriority.HIGH,
      channels: [NotificationChannel.PUSH, NotificationChannel.EMAIL, NotificationChannel.IN_APP],
      templateData: {
        senderName,
        listingTitle,
        messagePreview,
        chatUrl,
        userName: 'Utilisateur' // Récupérer le vrai nom
      }
    });
  }

  /**
   * Envoyer une notification de nouvelle offre
   */
  async sendNewOfferNotification(
    userId: string,
    buyerName: string,
    amount: number,
    listingTitle: string,
    offerUrl: string
  ): Promise<void> {
    await this.sendNotification({
      userId,
      type: NotificationType.NEW_OFFER,
      title: `Nouvelle offre de ${buyerName}`,
      body: `Offre de ${amount}€ pour ${listingTitle}`,
      priority: NotificationPriority.HIGH,
      channels: [NotificationChannel.PUSH, NotificationChannel.EMAIL, NotificationChannel.IN_APP],
      templateData: {
        buyerName,
        amount: amount.toString(),
        listingTitle,
        offerUrl,
        userName: 'Vendeur'
      }
    });
  }

  /**
   * Envoyer une notification de vente confirmée
   */
  async sendListingSoldNotification(
    userId: string,
    listingTitle: string,
    amount: number,
    reviewUrl: string
  ): Promise<void> {
    await this.sendNotification({
      userId,
      type: NotificationType.LISTING_SOLD,
      title: `Félicitations ! ${listingTitle} a été vendu`,
      body: `Votre annonce a été vendue pour ${amount}€`,
      priority: NotificationPriority.NORMAL,
      channels: [NotificationChannel.PUSH, NotificationChannel.EMAIL, NotificationChannel.IN_APP],
      templateData: {
        listingTitle,
        amount: amount.toString(),
        reviewUrl,
        userName: 'Vendeur'
      }
    });
  }

  /**
   * OAuth Notifications - Specific methods for OAuth authentication flows
   */

  /**
   * Envoyer une notification de connexion OAuth réussie
   */
  async sendOAuthLoginSuccessNotification(
    userId: string,
    provider: 'google' | 'facebook',
    deviceInfo?: string,
    loginTime?: Date
  ): Promise<void> {
    const user = await User.findById(userId);
    if (!user) {
      logger.warn(`Utilisateur non trouvé pour notification OAuth: ${userId}`);
      return;
    }

    await this.sendNotification({
      userId,
      type: NotificationType.OAUTH_LOGIN_SUCCESS,
      title: `Connexion ${provider} réussie`,
      body: `Vous êtes maintenant connecté avec ${provider}`,
      priority: NotificationPriority.NORMAL,
      channels: [NotificationChannel.PUSH, NotificationChannel.EMAIL, NotificationChannel.IN_APP],
      templateData: {
        userName: user.username,
        provider: provider === 'google' ? 'Google' : 'Facebook',
        loginTime: (loginTime || new Date()).toLocaleString('fr-FR'),
        deviceInfo: deviceInfo || 'Appareil non spécifié',
        securityUrl: `${process.env.CLIENT_URL}/settings/security`
      }
    });
  }

  /**
   * Envoyer une notification de compte OAuth associé
   */
  async sendOAuthAccountLinkedNotification(
    userId: string,
    provider: 'google' | 'facebook'
  ): Promise<void> {
    const user = await User.findById(userId);
    if (!user) {
      logger.warn(`Utilisateur non trouvé pour notification OAuth: ${userId}`);
      return;
    }

    await this.sendNotification({
      userId,
      type: NotificationType.OAUTH_ACCOUNT_LINKED,
      title: `Compte ${provider} associé`,
      body: `Votre compte ${provider} a été associé avec succès`,
      priority: NotificationPriority.NORMAL,
      channels: [NotificationChannel.PUSH, NotificationChannel.EMAIL, NotificationChannel.IN_APP],
      templateData: {
        userName: user.username,
        provider: provider === 'google' ? 'Google' : 'Facebook',
        profileUrl: `${process.env.CLIENT_URL}/profile`
      }
    });
  }

  /**
   * Envoyer une notification de fusion de compte requise
   */
  async sendAccountMergeRequiredNotification(
    email: string,
    provider: 'google' | 'facebook',
    existingProvider: 'local' | 'google' | 'facebook'
  ): Promise<void> {
    // Pour cette notification, on n'a pas forcément un userId car le compte n'est pas encore lié
    // On peut chercher l'utilisateur par email pour avoir l'ID
    const user = await User.findOne({ email });
    if (!user) {
      logger.warn(`Utilisateur non trouvé pour notification de fusion: ${email}`);
      return;
    }

    await this.sendNotification({
      userId: user._id.toString(),
      type: NotificationType.ACCOUNT_MERGE_REQUIRED,
      title: 'Fusion de comptes requise',
      body: 'Un compte existe déjà avec cet email',
      priority: NotificationPriority.HIGH,
      channels: [NotificationChannel.EMAIL, NotificationChannel.IN_APP],
      templateData: {
        userName: user.username,
        email,
        provider: provider === 'google' ? 'Google' : 'Facebook',
        existingProvider: existingProvider === 'local' ? 'email' : 
                         existingProvider === 'google' ? 'Google' : 'Facebook',
        loginUrl: `${process.env.CLIENT_URL}/login`
      }
    });
  }

  /**
   * Envoyer une notification de nouveau fournisseur OAuth ajouté
   */
  async sendNewOAuthProviderAddedNotification(
    userId: string,
    newProvider: 'google' | 'facebook',
    existingProviders: string[]
  ): Promise<void> {
    const user = await User.findById(userId);
    if (!user) {
      logger.warn(`Utilisateur non trouvé pour notification OAuth: ${userId}`);
      return;
    }

    await this.sendNotification({
      userId,
      type: NotificationType.NEW_OAUTH_PROVIDER_ADDED,
      title: `${newProvider} ajouté à votre compte`,
      body: `Vous pouvez maintenant vous connecter avec ${newProvider}`,
      priority: NotificationPriority.NORMAL,
      channels: [NotificationChannel.PUSH, NotificationChannel.EMAIL, NotificationChannel.IN_APP],
      templateData: {
        userName: user.username,
        newProvider: newProvider === 'google' ? 'Google' : 'Facebook',
        existingProviders: existingProviders.join(', '),
        settingsUrl: `${process.env.CLIENT_URL}/settings/account`
      }
    });
  }

  /**
   * Envoyer une notification de vérification d'email OAuth
   */
  async sendOAuthEmailVerificationNotification(
    userId: string,
    provider: 'google' | 'facebook'
  ): Promise<void> {
    const user = await User.findById(userId);
    if (!user) {
      logger.warn(`Utilisateur non trouvé pour notification OAuth: ${userId}`);
      return;
    }

    await this.sendNotification({
      userId,
      type: NotificationType.ACCOUNT_VERIFIED,
      title: 'Email vérifié automatiquement',
      body: `Votre email a été vérifié via ${provider}`,
      priority: NotificationPriority.NORMAL,
      channels: [NotificationChannel.PUSH, NotificationChannel.EMAIL, NotificationChannel.IN_APP],
      templateData: {
        userName: user.username,
        provider: provider === 'google' ? 'Google' : 'Facebook',
        verificationMethod: 'OAuth',
        profileUrl: `${process.env.CLIENT_URL}/profile`
      }
    });
  }

  /**
   * Envoyer une alerte de sécurité OAuth
   */
  async sendOAuthSecurityAlertNotification(
    userId: string,
    alertType: 'suspicious_login' | 'new_device' | 'password_not_set',
    provider: 'google' | 'facebook',
    details?: Record<string, any>
  ): Promise<void> {
    const user = await User.findById(userId);
    if (!user) {
      logger.warn(`Utilisateur non trouvé pour alerte sécurité OAuth: ${userId}`);
      return;
    }

    const alertMessages = {
      suspicious_login: 'Connexion suspecte détectée',
      new_device: 'Nouvelle connexion depuis un appareil',
      password_not_set: 'Votre compte OAuth n\'a pas de mot de passe'
    };

    await this.sendNotification({
      userId,
      type: NotificationType.SECURITY_ALERT,
      title: `Alerte sécurité - ${alertMessages[alertType]}`,
      body: `Action détectée via ${provider}`,
      priority: NotificationPriority.URGENT,
      channels: [NotificationChannel.PUSH, NotificationChannel.EMAIL, NotificationChannel.IN_APP],
      templateData: {
        userName: user.username,
        provider: provider === 'google' ? 'Google' : 'Facebook',
        alertType,
        alertMessage: alertMessages[alertType],
        details: JSON.stringify(details || {}),
        securityUrl: `${process.env.CLIENT_URL}/settings/security`,
        timestamp: new Date().toLocaleString('fr-FR')
      }
    });
  }

  /**
   * Envoyer une notification de bienvenue spécifique OAuth
   */
  async sendOAuthWelcomeNotification(
    userId: string,
    provider: 'google' | 'facebook',
    isFirstTime: boolean = true
  ): Promise<void> {
    const user = await User.findById(userId);
    if (!user) {
      logger.warn(`Utilisateur non trouvé pour notification de bienvenue OAuth: ${userId}`);
      return;
    }

    const welcomeMessage = isFirstTime 
      ? `Bienvenue sur Gearted via ${provider} !`
      : `Reconnexion réussie via ${provider}`;

    await this.sendNotification({
      userId,
      type: NotificationType.WELCOME,
      title: welcomeMessage,
      body: 'Découvrez le marketplace #1 pour les passionnés d\'airsoft',
      priority: NotificationPriority.NORMAL,
      channels: [NotificationChannel.PUSH, NotificationChannel.EMAIL, NotificationChannel.IN_APP],
      templateData: {
        userName: user.username,
        provider: provider === 'google' ? 'Google' : 'Facebook',
        isFirstTime: isFirstTime ? 'true' : 'false',
        appUrl: process.env.CLIENT_URL || 'https://gearted.com',
        profileUrl: `${process.env.CLIENT_URL}/profile`,
        helpUrl: `${process.env.CLIENT_URL}/help`
      }
    });
  }

  /**
   * Méthode helper pour récupérer les informations de l'utilisateur OAuth
   */
  private async getOAuthUserInfo(userId: string): Promise<{
    user: any;
    hasPassword: boolean;
    connectedProviders: string[];
  } | null> {
    try {
      const user = await User.findById(userId);
      if (!user) return null;

      const connectedProviders = [];
      if (user.provider === 'local' || user.password) connectedProviders.push('email');
      if (user.googleId) connectedProviders.push('google');
      if (user.facebookId) connectedProviders.push('facebook');

      return {
        user,
        hasPassword: !!user.password,
        connectedProviders
      };
    } catch (error) {
      logger.error(`Erreur récupération info utilisateur OAuth ${userId}: ${error instanceof Error ? error.message : String(error)}`);
      return null;
    }
  }

  /**
   * Mettre à jour le token FCM d'un utilisateur
   */
  async updateUserFCMToken(userId: string, fcmToken: string): Promise<void> {
    try {
      await User.findByIdAndUpdate(userId, { fcmToken });
      logger.info(`Token FCM mis à jour pour l'utilisateur ${userId}`);
    } catch (error) {
      logger.error(`Erreur mise à jour token FCM pour ${userId}: ${error instanceof Error ? error.message : String(error)}`);
    }
  }

  /**
   * Supprimer le token FCM d'un utilisateur (déconnexion)
   */
  async removeUserFCMToken(userId: string): Promise<void> {
    try {
      await User.findByIdAndUpdate(userId, { $unset: { fcmToken: 1 } });
      logger.info(`Token FCM supprimé pour l'utilisateur ${userId}`);
    } catch (error) {
      logger.error(`Erreur suppression token FCM pour ${userId}: ${error instanceof Error ? error.message : String(error)}`);
    }
  }

  /**
   * Vérifier si un utilisateur a des méthodes de connexion multiples
   */
  async hasMultipleLoginMethods(userId: string): Promise<boolean> {
    try {
      const user = await User.findById(userId);
      if (!user) return false;

      let methodCount = 0;
      if (user.password) methodCount++; // Email/password
      if (user.googleId) methodCount++; // Google
      if (user.facebookId) methodCount++; // Facebook

      return methodCount > 1;
    } catch (error) {
      logger.error(`Erreur vérification méthodes connexion pour ${userId}: ${error instanceof Error ? error.message : String(error)}`);
      return false;
    }
  }
}

export default NotificationService.getInstance();
