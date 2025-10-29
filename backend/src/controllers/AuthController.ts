import { Request, Response } from 'express';
import { AuthService } from '../services/AuthService';
// TODO: We'll need to import Prisma client when we have database setup
// import { prisma } from '../utils/database';

interface RegisterRequest {
  email: string;
  username?: string;
  password: string;
  firstName?: string;
  lastName?: string;
}

interface LoginRequest {
  email: string;
  password: string;
}

export class AuthController {
  /**
   * Register a new user
   */
  static async register(req: Request, res: Response): Promise<void> {
    try {
      const { email, username, password, firstName, lastName }: RegisterRequest = req.body;

      // Validate input
      if (!email || !password) {
        res.status(400).json({
          success: false,
          error: {
            message: 'Email and password are required'
          }
        });
        return;
      }

      // Validate email format
      if (!AuthService.validateEmail(email)) {
        res.status(400).json({
          success: false,
          error: {
            message: 'Invalid email format'
          }
        });
        return;
      }

      // Validate password strength
      const passwordValidation = AuthService.validatePassword(password);
      if (!passwordValidation.isValid) {
        res.status(400).json({
          success: false,
          error: {
            message: 'Password does not meet requirements',
            details: passwordValidation.errors
          }
        });
        return;
      }

      // TODO: Check if user already exists
      // const existingUser = await prisma.user.findFirst({
      //   where: {
      //     OR: [
      //       { email: email.toLowerCase() },
      //       { username: username }
      //     ]
      //   }
      // });

      // if (existingUser) {
      //   res.status(409).json({
      //     success: false,
      //     error: {
      //       message: existingUser.email === email.toLowerCase() 
      //         ? 'Email already registered' 
      //         : 'Username already taken'
      //     }
      //   });
      //   return;
      // }

      // Hash password
      const hashedPassword = await AuthService.hashPassword(password);

      // Generate username if not provided
      const finalUsername = username || AuthService.generateUsername(email);

      // Create email verification token
      const { token: emailVerificationToken, expires: emailVerificationExpires } = 
        AuthService.createEmailVerificationToken();

      // TODO: Create user in database
      // const user = await prisma.user.create({
      //   data: {
      //     email: email.toLowerCase(),
      //     username: finalUsername,
      //     password: hashedPassword,
      //     firstName,
      //     lastName,
      //     emailVerificationToken,
      //     emailVerificationExpires
      //   }
      // });

      // For now, mock user creation
      const mockUser = {
        id: 'mock-user-id',
        email: email.toLowerCase(),
        username: finalUsername,
        firstName,
        lastName,
        role: 'USER',
        isEmailVerified: false,
        createdAt: new Date()
      };

      // Generate tokens
      const tokens = AuthService.generateTokens({
        userId: mockUser.id,
        email: mockUser.email,
        role: mockUser.role
      });

      // TODO: Save refresh token to database
      // await prisma.user.update({
      //   where: { id: user.id },
      //   data: { refreshToken: tokens.refreshToken }
      // });

      // TODO: Send verification email
      // await EmailService.sendVerificationEmail(user.email, emailVerificationToken);

      // Return success response
      res.status(201).json({
        success: true,
        data: {
          user: AuthService.sanitizeUser(mockUser),
          tokens,
          message: 'Registration successful. Please check your email for verification.'
        }
      });

    } catch (error) {
      console.error('Registration error:', error);
      res.status(500).json({
        success: false,
        error: {
          message: 'Registration failed'
        }
      });
    }
  }

  /**
   * Login user
   */
  static async login(req: Request, res: Response): Promise<void> {
    try {
      const { email, password }: LoginRequest = req.body;

      if (!email || !password) {
        res.status(400).json({
          success: false,
          error: {
            message: 'Email and password are required'
          }
        });
        return;
      }

      // TODO: Find user in database
      // const user = await prisma.user.findUnique({
      //   where: { email: email.toLowerCase() }
      // });

      // if (!user) {
      //   res.status(401).json({
      //     success: false,
      //     error: {
      //       message: 'Invalid credentials'
      //     }
      //   });
      //   return;
      // }

      // For now, mock user lookup
      if (email !== 'test@gearted.com') {
        res.status(401).json({
          success: false,
          error: {
            message: 'Invalid credentials'
          }
        });
        return;
      }

      const mockUser = {
        id: 'mock-user-id',
        email: 'test@gearted.com',
        username: 'testuser',
        password: await AuthService.hashPassword('Test123!'),
        role: 'USER',
        isActive: true,
        firstName: 'Test',
        lastName: 'User'
      };

      // Check if account is active
      if (!mockUser.isActive) {
        res.status(401).json({
          success: false,
          error: {
            message: 'Account is disabled'
          }
        });
        return;
      }

      // Verify password
      const isPasswordValid = await AuthService.comparePassword(password, mockUser.password);
      if (!isPasswordValid) {
        res.status(401).json({
          success: false,
          error: {
            message: 'Invalid credentials'
          }
        });
        return;
      }

      // Generate tokens
      const tokens = AuthService.generateTokens({
        userId: mockUser.id,
        email: mockUser.email,
        role: mockUser.role
      });

      // TODO: Update refresh token in database
      // await prisma.user.update({
      //   where: { id: user.id },
      //   data: { 
      //     refreshToken: tokens.refreshToken,
      //     lastActiveAt: new Date()
      //   }
      // });

      res.json({
        success: true,
        data: {
          user: AuthService.sanitizeUser(mockUser),
          tokens
        }
      });

    } catch (error) {
      console.error('Login error:', error);
      res.status(500).json({
        success: false,
        error: {
          message: 'Login failed'
        }
      });
    }
  }

  /**
   * Refresh access token
   */
  static async refreshToken(req: Request, res: Response): Promise<void> {
    try {
      const { refreshToken } = req.body;

      if (!refreshToken) {
        res.status(400).json({
          success: false,
          error: {
            message: 'Refresh token is required'
          }
        });
        return;
      }

      const payload = AuthService.verifyRefreshToken(refreshToken);
      if (!payload) {
        res.status(401).json({
          success: false,
          error: {
            message: 'Invalid refresh token'
          }
        });
        return;
      }

      // TODO: Find user and verify refresh token
      // const user = await prisma.user.findUnique({
      //   where: { id: payload.userId }
      // });

      // if (!user || user.refreshToken !== refreshToken) {
      //   res.status(401).json({
      //     success: false,
      //     error: {
      //       message: 'Invalid refresh token'
      //     }
      //   });
      //   return;
      // }

      // Mock user for now
      const mockUser = {
        id: payload.userId,
        email: 'test@gearted.com',
        role: 'USER'
      };

      // Generate new tokens
      const tokens = AuthService.generateTokens({
        userId: mockUser.id,
        email: mockUser.email,
        role: mockUser.role
      });

      // TODO: Update refresh token in database
      // await prisma.user.update({
      //   where: { id: user.id },
      //   data: { refreshToken: tokens.refreshToken }
      // });

      res.json({
        success: true,
        data: { tokens }
      });

    } catch (error) {
      console.error('Token refresh error:', error);
      res.status(500).json({
        success: false,
        error: {
          message: 'Token refresh failed'
        }
      });
    }
  }

  /**
   * Logout user
   */
  static async logout(req: Request, res: Response): Promise<void> {
    try {
      const userId = req.user?.userId;

      if (userId) {
        // TODO: Clear refresh token from database
        // await prisma.user.update({
        //   where: { id: userId },
        //   data: { refreshToken: null }
        // });
      }

      res.json({
        success: true,
        data: {
          message: 'Logged out successfully'
        }
      });

    } catch (error) {
      console.error('Logout error:', error);
      res.status(500).json({
        success: false,
        error: {
          message: 'Logout failed'
        }
      });
    }
  }

  /**
   * Get current user profile
   */
  static async getProfile(req: Request, res: Response): Promise<void> {
    try {
      const userId = req.user?.userId;

      if (!userId) {
        res.status(401).json({
          success: false,
          error: {
            message: 'Authentication required'
          }
        });
        return;
      }

      // TODO: Get user from database
      // const user = await prisma.user.findUnique({
      //   where: { id: userId },
      //   include: {
      //     userStats: true
      //   }
      // });

      // Mock user for now
      const mockUser = {
        id: userId,
        email: 'test@gearted.com',
        username: 'testuser',
        firstName: 'Test',
        lastName: 'User',
        role: 'USER',
        isEmailVerified: true,
        createdAt: new Date()
      };

      res.json({
        success: true,
        data: {
          user: AuthService.sanitizeUser(mockUser)
        }
      });

    } catch (error) {
      console.error('Get profile error:', error);
      res.status(500).json({
        success: false,
        error: {
          message: 'Failed to get profile'
        }
      });
    }
  }
}