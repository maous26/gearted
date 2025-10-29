import { NextFunction, Request, Response } from 'express';
import Joi from 'joi';

export const validateRequest = (schema: {
  body?: Joi.ObjectSchema;
  query?: Joi.ObjectSchema;
  params?: Joi.ObjectSchema;
}) => {
  return (req: Request, res: Response, next: NextFunction): void => {
    const errors: string[] = [];

    // Validate body
    if (schema.body) {
      const { error } = schema.body.validate(req.body);
      if (error) {
        errors.push(...error.details.map(detail => detail.message));
      }
    }

    // Validate query parameters
    if (schema.query) {
      const { error } = schema.query.validate(req.query);
      if (error) {
        errors.push(...error.details.map(detail => detail.message));
      }
    }

    // Validate route parameters
    if (schema.params) {
      const { error } = schema.params.validate(req.params);
      if (error) {
        errors.push(...error.details.map(detail => detail.message));
      }
    }

    if (errors.length > 0) {
      res.status(400).json({
        success: false,
        error: {
          message: 'Validation failed',
          details: errors
        }
      });
      return;
    }

    next();
  };
};