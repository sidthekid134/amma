import { z } from 'zod';
import { modelSchemas, ModelType } from '../models/schemas';

/**
 * Utility class for serializing and deserializing model data
 */
export class ModelSerializer {
  /**
   * Serialize a model instance to JSON
   * @param data Model instance to serialize
   * @returns JSON string representation
   */
  static serialize<T extends ModelType>(data: T): string {
    return JSON.stringify(data, (key, value) => {
      // Special handling for Date objects
      if (value instanceof Date) {
        return { __type: 'Date', value: value.toISOString() };
      }
      return value;
    });
  }

  /**
   * Deserialize JSON to a model instance
   * @param json JSON string to deserialize
   * @param modelName Name of the model to deserialize to
   * @returns Deserialized and validated model instance
   */
  static deserialize<T extends ModelType>(json: string, modelName: keyof typeof modelSchemas): T {
    // First parse the JSON
    const parsed = JSON.parse(json, (key, value) => {
      // Restore Date objects
      if (typeof value === 'object' && 
          value !== null && 
          value.__type === 'Date') {
        return new Date(value.value);
      }
      return value;
    });
    
    // Then validate against the model schema
    const schema = modelSchemas[modelName];
    return schema.parse(parsed) as T;
  }

  /**
   * Export a model instance to a plain JSON object
   * (useful for APIs, file exports, etc.)
   * @param data Model instance to export
   * @returns Plain object representation
   */
  static toJSON<T extends ModelType>(data: T): Record<string, any> {
    return JSON.parse(this.serialize(data));
  }

  /**
   * Import a plain object and convert to a validated model instance
   * @param data Plain object to import
   * @param modelName Name of the model to convert to
   * @returns Validated model instance
   */
  static fromJSON<T extends ModelType>(data: Record<string, any>, modelName: keyof typeof modelSchemas): T {
    // Convert any date strings to Date objects
    const processed = this.processJsonDates(data);
    
    // Validate against the model schema
    const schema = modelSchemas[modelName];
    return schema.parse(processed) as T;
  }

  /**
   * Process a JSON object recursively and convert ISO date strings to Date objects
   * @param obj Object to process
   * @returns Processed object with Date objects
   */
  private static processJsonDates(obj: any): any {
    if (obj === null || obj === undefined) {
      return obj;
    }

    if (typeof obj === 'string') {
      // Check if string is an ISO date format
      const isoDatePattern = /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d{3})?Z$/;
      if (isoDatePattern.test(obj)) {
        const date = new Date(obj);
        if (!isNaN(date.getTime())) {
          return date;
        }
      }
      return obj;
    }

    if (Array.isArray(obj)) {
      return obj.map(item => this.processJsonDates(item));
    }

    if (typeof obj === 'object') {
      const result: Record<string, any> = {};
      for (const key in obj) {
        if (Object.prototype.hasOwnProperty.call(obj, key)) {
          result[key] = this.processJsonDates(obj[key]);
        }
      }
      return result;
    }

    return obj;
  }

  /**
   * Create a clone of a model instance
   * @param data Model instance to clone
   * @param modelName Name of the model
   * @returns Cloned model instance
   */
  static clone<T extends ModelType>(data: T, modelName: keyof typeof modelSchemas): T {
    return this.deserialize<T>(this.serialize(data), modelName);
  }

  /**
   * Export multiple model instances to JSON
   * @param items Array of model instances
   * @returns JSON string representation of the array
   */
  static serializeArray<T extends ModelType>(items: T[]): string {
    return JSON.stringify(items, (key, value) => {
      if (value instanceof Date) {
        return { __type: 'Date', value: value.toISOString() };
      }
      return value;
    });
  }

  /**
   * Deserialize JSON to an array of model instances
   * @param json JSON string to deserialize
   * @param modelName Name of the model for the array items
   * @returns Array of deserialized and validated model instances
   */
  static deserializeArray<T extends ModelType>(json: string, modelName: keyof typeof modelSchemas): T[] {
    // Parse the JSON
    const parsed = JSON.parse(json, (key, value) => {
      if (typeof value === 'object' && 
          value !== null && 
          value.__type === 'Date') {
        return new Date(value.value);
      }
      return value;
    });
    
    if (!Array.isArray(parsed)) {
      throw new Error('Expected JSON array for deserializeArray');
    }
    
    // Validate each item against the model schema
    const schema = modelSchemas[modelName];
    const arraySchema = z.array(schema);
    
    return arraySchema.parse(parsed) as T[];
  }
}