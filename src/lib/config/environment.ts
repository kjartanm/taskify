// Environment configuration validation for Taskify MVP
// This file validates all required environment variables at application startup

export interface EnvironmentConfig {
  NODE_ENV: 'development' | 'staging' | 'production';
  VITE_API_BASE_URL: string;
  VITE_APP_NAME: string;
  VITE_LOG_LEVEL: 'debug' | 'info' | 'warn' | 'error';
  CLOUDFLARE_API_TOKEN?: string;
  CLOUDFLARE_ACCOUNT_ID?: string;
  CLOUDFLARE_PROJECT_NAME?: string;
  DATABASE_URL?: string;
  DB_BINDING: string;
  KV_BINDING: string;
}

export function validateEnvironmentConfig(): EnvironmentConfig {
  const config: Partial<EnvironmentConfig> = {
    NODE_ENV: process.env.NODE_ENV as EnvironmentConfig['NODE_ENV'],
    VITE_API_BASE_URL: process.env.VITE_API_BASE_URL,
    VITE_APP_NAME: process.env.VITE_APP_NAME,
    VITE_LOG_LEVEL: process.env.VITE_LOG_LEVEL as EnvironmentConfig['VITE_LOG_LEVEL'],
    CLOUDFLARE_API_TOKEN: process.env.CLOUDFLARE_API_TOKEN,
    CLOUDFLARE_ACCOUNT_ID: process.env.CLOUDFLARE_ACCOUNT_ID,
    CLOUDFLARE_PROJECT_NAME: process.env.CLOUDFLARE_PROJECT_NAME,
    DATABASE_URL: process.env.DATABASE_URL,
    DB_BINDING: process.env.DB_BINDING,
    KV_BINDING: process.env.KV_BINDING,
  };

  // Required variables for all environments
  const requiredVariables = [
    'NODE_ENV',
    'VITE_API_BASE_URL',
    'VITE_APP_NAME',
    'VITE_LOG_LEVEL',
    'DB_BINDING',
    'KV_BINDING',
  ];

  // Additional required variables for production and staging
  const productionRequiredVariables = [
    'CLOUDFLARE_API_TOKEN',
    'CLOUDFLARE_ACCOUNT_ID',
    'CLOUDFLARE_PROJECT_NAME',
  ];

  // Validate required variables
  for (const variable of requiredVariables) {
    if (!config[variable as keyof EnvironmentConfig]) {
      throw new Error(`Missing required environment variable: ${variable}`);
    }
  }

  // Validate production-specific variables
  if (config.NODE_ENV === 'production' || config.NODE_ENV === 'staging') {
    for (const variable of productionRequiredVariables) {
      if (!config[variable as keyof EnvironmentConfig]) {
        throw new Error(`Missing required environment variable for ${config.NODE_ENV}: ${variable}`);
      }
    }
  }

  // Validate NODE_ENV values
  if (!['development', 'staging', 'production'].includes(config.NODE_ENV!)) {
    throw new Error(`Invalid NODE_ENV: ${config.NODE_ENV}. Must be 'development', 'staging', or 'production'`);
  }

  // Validate LOG_LEVEL values
  if (!['debug', 'info', 'warn', 'error'].includes(config.VITE_LOG_LEVEL!)) {
    throw new Error(`Invalid VITE_LOG_LEVEL: ${config.VITE_LOG_LEVEL}. Must be 'debug', 'info', 'warn', or 'error'`);
  }

  // Validate URL format
  if (config.VITE_API_BASE_URL && !isValidUrl(config.VITE_API_BASE_URL)) {
    throw new Error(`Invalid VITE_API_BASE_URL format: ${config.VITE_API_BASE_URL}`);
  }

  return config as EnvironmentConfig;
}

function isValidUrl(url: string): boolean {
  try {
    new URL(url);
    return true;
  } catch {
    return false;
  }
}

// Export validated configuration
export const env = validateEnvironmentConfig();
