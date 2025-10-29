import bcrypt from 'bcryptjs';
import crypto from 'crypto';
import jwt from 'jsonwebtoken';

interface TokenPayload {
  userId: string;
  email: string;
  role: string;
}

interface TokenPair {
  accessToken: string;
  refreshToken: string;
}

export class AuthService {
  private static readonly ACCESS_TOKEN_EXPIRY = process.env.JWT_ACCESS_EXPIRE || '15m';
  private static readonly REFRESH_TOKEN_EXPIRY = process.env.JWT_REFRESH_EXPIRE || '7d';
  private static readonly SALT_ROUNDS = parseInt(process.env.BCRYPT_ROUNDS || '12');

  /**
   * Hash a password using bcrypt
   */
  static async hashPassword(password: string): Promise<string> {
    return bcrypt.hash(password, this.SALT_ROUNDS);
  }

  /**
   * Compare a plain password with a hashed password
   */
  static async comparePassword(password: string, hashedPassword: string): Promise<boolean> {
    return bcrypt.compare(password, hashedPassword);
  }

  /**
   * Generate access and refresh tokens
   */
  static generateTokens(payload: TokenPayload): TokenPair {
    const accessSecret = process.env.JWT_ACCESS_SECRET;
    const refreshSecret = process.env.JWT_REFRESH_SECRET;
    
    if (!accessSecret || !refreshSecret) {
      throw new Error('JWT secrets are not configured');
    }

    const accessToken = jwt.sign(payload, accessSecret, { 
      expiresIn: this.ACCESS_TOKEN_EXPIRY 
    } as jwt.SignOptions);

    const refreshToken = jwt.sign({ userId: payload.userId }, refreshSecret, { 
      expiresIn: this.REFRESH_TOKEN_EXPIRY 
    } as jwt.SignOptions);

    return { accessToken, refreshToken };
  }

  /**
   * Verify an access token
   */
  static verifyAccessToken(token: string): TokenPayload | null {
    try {
      if (!process.env.JWT_ACCESS_SECRET) {
        throw new Error('JWT access secret is not configured');
      }
      return jwt.verify(token, process.env.JWT_ACCESS_SECRET) as TokenPayload;
    } catch (error) {
      return null;
    }
  }

  /**
   * Verify a refresh token
   */
  static verifyRefreshToken(token: string): { userId: string } | null {
    try {
      if (!process.env.JWT_REFRESH_SECRET) {
        throw new Error('JWT refresh secret is not configured');
      }
      return jwt.verify(token, process.env.JWT_REFRESH_SECRET) as { userId: string };
    } catch (error) {
      return null;
    }
  }

  /**
   * Generate a secure random token for email verification, password reset, etc.
   */
  static generateSecureToken(): string {
    return crypto.randomBytes(32).toString('hex');
  }

  /**
   * Generate a verification code (6 digits)
   */
  static generateVerificationCode(): string {
    return Math.floor(100000 + Math.random() * 900000).toString();
  }

  /**
   * Create password reset token with expiration
   */
  static createPasswordResetToken(): { token: string; expires: Date } {
    const token = this.generateSecureToken();
    const expires = new Date(Date.now() + 60 * 60 * 1000); // 1 hour from now
    return { token, expires };
  }

  /**
   * Create email verification token with expiration
   */
  static createEmailVerificationToken(): { token: string; expires: Date } {
    const token = this.generateSecureToken();
    const expires = new Date(Date.now() + 24 * 60 * 60 * 1000); // 24 hours from now
    return { token, expires };
  }

  /**
   * Validate password strength
   */
  static validatePassword(password: string): { isValid: boolean; errors: string[] } {
    const errors: string[] = [];

    if (password.length < 8) {
      errors.push('Password must be at least 8 characters long');
    }

    if (!/(?=.*[a-z])/.test(password)) {
      errors.push('Password must contain at least one lowercase letter');
    }

    if (!/(?=.*[A-Z])/.test(password)) {
      errors.push('Password must contain at least one uppercase letter');
    }

    if (!/(?=.*\d)/.test(password)) {
      errors.push('Password must contain at least one number');
    }

    if (!/(?=.*[@$!%*?&])/.test(password)) {
      errors.push('Password must contain at least one special character (@$!%*?&)');
    }

    return {
      isValid: errors.length === 0,
      errors
    };
  }

  /**
   * Validate email format
   */
  static validateEmail(email: string): boolean {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  }

  /**
   * Generate username from email if not provided
   */
  static generateUsername(email: string, existingUsernames: string[] = []): string {
    const baseUsername = email.split('@')[0].toLowerCase().replace(/[^a-z0-9]/g, '');
    let username = baseUsername;
    let counter = 1;

    while (existingUsernames.includes(username)) {
      username = `${baseUsername}${counter}`;
      counter++;
    }

    return username;
  }

  /**
   * Sanitize user data for public consumption (remove sensitive fields)
   */
  static sanitizeUser(user: any) {
    const {
      password,
      refreshToken,
      emailVerificationToken,
      passwordResetToken,
      ...sanitizedUser
    } = user;

    return sanitizedUser;
  }
}