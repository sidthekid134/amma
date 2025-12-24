import AsyncStorage from '@react-native-async-storage/async-storage';
import { z } from 'zod';
import { modelSchemas, ModelType } from '../models/schemas';

// Type for model names
export type ModelName = keyof typeof modelSchemas;

// Storage key prefixes
const KEYS = {
  PREFIX: '@SousChef:',
  INDEX: 'index:',
  DATA: 'data:',
  SCHEMA_VERSION: 'schema_version',
};

// Error types
export class StorageError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'StorageError';
  }
}

export class ValidationError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'ValidationError';
  }
}

/**
 * Handles serialization and deserialization of data for storage
 */
export class Serializer {
  /**
   * Serialize data for storage
   * @param data Data to serialize
   * @returns JSON string
   */
  static serialize(data: any): string {
    return JSON.stringify(data, (key, value) => {
      // Handle Date objects
      if (value instanceof Date) {
        return { __type: 'Date', value: value.toISOString() };
      }
      return value;
    });
  }

  /**
   * Deserialize data from storage
   * @param data JSON string to deserialize
   * @returns Deserialized data with Date objects restored
   */
  static deserialize(data: string): any {
    return JSON.parse(data, (key, value) => {
      // Restore Date objects
      if (typeof value === 'object' && 
          value !== null && 
          value.__type === 'Date') {
        return new Date(value.value);
      }
      return value;
    });
  }
}

/**
 * AsyncStorage wrapper for type-safe storage of recipe data models
 */
export class Storage {
  /**
   * Get the current schema version
   */
  static async getSchemaVersion(): Promise<number> {
    const version = await AsyncStorage.getItem(`${KEYS.PREFIX}${KEYS.SCHEMA_VERSION}`);
    return version ? parseInt(version, 10) : 1;
  }

  /**
   * Update the schema version
   * @param version New schema version
   */
  static async updateSchemaVersion(version: number): Promise<void> {
    await AsyncStorage.setItem(`${KEYS.PREFIX}${KEYS.SCHEMA_VERSION}`, version.toString());
  }

  /**
   * Get the storage key for a model's index
   * @param modelName Name of the model
   * @returns Storage key for the index
   */
  private static getIndexKey(modelName: ModelName): string {
    return `${KEYS.PREFIX}${KEYS.INDEX}${modelName}`;
  }

  /**
   * Get the storage key for a model instance
   * @param modelName Name of the model
   * @param id ID of the model instance
   * @returns Storage key for the model instance
   */
  private static getItemKey(modelName: ModelName, id: string): string {
    return `${KEYS.PREFIX}${KEYS.DATA}${modelName}:${id}`;
  }

  /**
   * Get the IDs of all stored instances of a model
   * @param modelName Name of the model
   * @returns Array of model instance IDs
   */
  private static async getIndex(modelName: ModelName): Promise<string[]> {
    const indexKey = this.getIndexKey(modelName);
    const index = await AsyncStorage.getItem(indexKey);
    return index ? Serializer.deserialize(index) : [];
  }

  /**
   * Update the index of stored model instances
   * @param modelName Name of the model
   * @param ids Array of model instance IDs
   */
  private static async updateIndex(modelName: ModelName, ids: string[]): Promise<void> {
    const indexKey = this.getIndexKey(modelName);
    await AsyncStorage.setItem(indexKey, Serializer.serialize(ids));
  }

  /**
   * Add an ID to a model's index
   * @param modelName Name of the model
   * @param id ID to add
   */
  private static async addToIndex(modelName: ModelName, id: string): Promise<void> {
    const index = await this.getIndex(modelName);
    if (!index.includes(id)) {
      index.push(id);
      await this.updateIndex(modelName, index);
    }
  }

  /**
   * Remove an ID from a model's index
   * @param modelName Name of the model
   * @param id ID to remove
   */
  private static async removeFromIndex(modelName: ModelName, id: string): Promise<void> {
    const index = await this.getIndex(modelName);
    const newIndex = index.filter(itemId => itemId !== id);
    await this.updateIndex(modelName, newIndex);
  }

  /**
   * Validate data against a model schema
   * @param modelName Name of the model
   * @param data Data to validate
   * @returns Validated and parsed data
   * @throws ValidationError if validation fails
   */
  private static validateData<T extends ModelType>(modelName: ModelName, data: any): T {
    const schema = modelSchemas[modelName];
    try {
      return schema.parse(data) as T;
    } catch (error) {
      if (error instanceof z.ZodError) {
        throw new ValidationError(`Invalid ${modelName} data: ${error.message}`);
      }
      throw error;
    }
  }

  /**
   * Create a new model instance in storage
   * @param modelName Name of the model
   * @param data Data for the new model instance
   * @returns Created model instance
   */
  static async create<T extends ModelType>(modelName: ModelName, data: Omit<T, 'id' | 'createdAt' | 'updatedAt' | 'schemaVersion'>): Promise<T> {
    // Add default values
    const currentSchemaVersion = await this.getSchemaVersion();
    const now = new Date();
    const dataWithDefaults = {
      id: crypto.randomUUID(),
      createdAt: now,
      updatedAt: now,
      schemaVersion: currentSchemaVersion,
      ...data,
    };

    // Validate data
    const validData = this.validateData<T>(modelName, dataWithDefaults);
    
    // Save data
    const key = this.getItemKey(modelName, validData.id as string);
    await AsyncStorage.setItem(key, Serializer.serialize(validData));
    
    // Update index
    await this.addToIndex(modelName, validData.id as string);
    
    return validData;
  }

  /**
   * Get a model instance from storage
   * @param modelName Name of the model
   * @param id ID of the model instance
   * @returns Model instance or null if not found
   */
  static async get<T extends ModelType>(modelName: ModelName, id: string): Promise<T | null> {
    const key = this.getItemKey(modelName, id);
    const data = await AsyncStorage.getItem(key);
    
    if (!data) {
      return null;
    }
    
    const parsed = Serializer.deserialize(data);
    return this.validateData<T>(modelName, parsed);
  }

  /**
   * Get all instances of a model from storage
   * @param modelName Name of the model
   * @returns Array of model instances
   */
  static async getAll<T extends ModelType>(modelName: ModelName): Promise<T[]> {
    const index = await this.getIndex(modelName);
    const items: T[] = [];
    
    for (const id of index) {
      const item = await this.get<T>(modelName, id);
      if (item) {
        items.push(item);
      }
    }
    
    return items;
  }

  /**
   * Update a model instance in storage
   * @param modelName Name of the model
   * @param id ID of the model instance
   * @param data Updated data
   * @returns Updated model instance
   */
  static async update<T extends ModelType>(
    modelName: ModelName, 
    id: string, 
    data: Partial<Omit<T, 'id' | 'createdAt' | 'schemaVersion'>>
  ): Promise<T | null> {
    // Get existing data
    const existing = await this.get<T>(modelName, id);
    
    if (!existing) {
      return null;
    }
    
    // Merge with updates and update metadata
    const merged = {
      ...existing,
      ...data,
      updatedAt: new Date(),
    };
    
    // Validate merged data
    const validData = this.validateData<T>(modelName, merged);
    
    // Save updated data
    const key = this.getItemKey(modelName, id);
    await AsyncStorage.setItem(key, Serializer.serialize(validData));
    
    return validData;
  }

  /**
   * Delete a model instance from storage
   * @param modelName Name of the model
   * @param id ID of the model instance
   * @returns true if deleted, false if not found
   */
  static async delete(modelName: ModelName, id: string): Promise<boolean> {
    const key = this.getItemKey(modelName, id);
    const data = await AsyncStorage.getItem(key);
    
    if (!data) {
      return false;
    }
    
    await AsyncStorage.removeItem(key);
    await this.removeFromIndex(modelName, id);
    
    return true;
  }

  /**
   * Delete all instances of a model from storage
   * @param modelName Name of the model
   */
  static async deleteAll(modelName: ModelName): Promise<void> {
    const index = await this.getIndex(modelName);
    
    for (const id of index) {
      const key = this.getItemKey(modelName, id);
      await AsyncStorage.removeItem(key);
    }
    
    await this.updateIndex(modelName, []);
  }

  /**
   * Find model instances matching a predicate
   * @param modelName Name of the model
   * @param predicate Function to test each model instance
   * @returns Array of matching model instances
   */
  static async find<T extends ModelType>(
    modelName: ModelName, 
    predicate: (item: T) => boolean
  ): Promise<T[]> {
    const items = await this.getAll<T>(modelName);
    return items.filter(predicate);
  }

  /**
   * Clear all data from storage
   */
  static async clearAll(): Promise<void> {
    const keys = await AsyncStorage.getAllKeys();
    const souschefKeys = keys.filter(key => key.startsWith(KEYS.PREFIX));
    await AsyncStorage.multiRemove(souschefKeys);
  }

  /**
   * Perform a migration of stored data to a new schema version
   * @param migrations Migration functions to apply
   * @param targetVersion Target schema version
   */
  static async migrate(
    migrations: Record<number, (data: any) => any>,
    targetVersion: number
  ): Promise<void> {
    const currentVersion = await this.getSchemaVersion();
    
    if (currentVersion >= targetVersion) {
      return; // Already at or above target version
    }
    
    // Get all model types
    const modelNames = Object.keys(modelSchemas) as ModelName[];
    
    for (const modelName of modelNames) {
      const index = await this.getIndex(modelName);
      
      for (const id of index) {
        const key = this.getItemKey(modelName, id);
        const rawData = await AsyncStorage.getItem(key);
        
        if (rawData) {
          let data = Serializer.deserialize(rawData);
          let version = data.schemaVersion || 1;
          
          // Apply migrations sequentially
          while (version < targetVersion && migrations[version]) {
            data = migrations[version](data);
            version++;
          }
          
          // Update schema version and save
          data.schemaVersion = targetVersion;
          await AsyncStorage.setItem(key, Serializer.serialize(data));
        }
      }
    }
    
    // Update schema version
    await this.updateSchemaVersion(targetVersion);
  }
}