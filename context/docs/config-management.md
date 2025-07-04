# Configuration Management

## Overview

Taskify MVP uses a three-tier configuration strategy with secure environment-specific settings across development, staging, and production environments.

## Environment Variables

### Development (.env files)
```bash
# Copy and customize
cp .env.example .env

# Required variables
NODE_ENV=development
VITE_API_BASE_URL=http://localhost:5173
VITE_APP_NAME=Taskify MVP
VITE_LOG_LEVEL=debug
DB_BINDING=DB
KV_BINDING=KV
```

### Staging/Production (Cloudflare KV + Secrets)
```bash
# Set secrets (sensitive data)
wrangler secret put API_KEY --env staging
wrangler secret put DATABASE_PASSWORD --env production

# View secrets
npm run secrets:list:staging
npm run secrets:list:production

# KV configuration storage
wrangler kv:namespace create "CONFIG" --env staging
```

## Configuration Validation

The app validates all environment variables at startup using TypeScript:

```typescript
import { env } from '$lib/config/environment';

// Automatically validates and throws errors for missing/invalid config
console.log(env.NODE_ENV); // Type-safe access
```

## Environment Tiers

| Environment | Config Method | Database | KV Namespace |
|-------------|---------------|----------|--------------|
| Development | `.env` files | Local SQLite | Local KV |
| Staging | Cloudflare KV + Secrets | D1 Staging | KV Staging |
| Production | Cloudflare KV + Secrets | D1 Production | KV Production |

## Quick Commands

```bash
# Validate current configuration
npm run config:validate

# Deploy with environment
npm run wrangler:deploy:staging
npm run wrangler:deploy:production

# Manage secrets
npm run secrets:list
npm run secrets:list:staging
npm run secrets:list:production
```

## Security

- **Never commit** `.env` files to version control
- **Use Wrangler secrets** for sensitive data in staging/production
- **Validate configuration** at application startup
- **Follow principle of least privilege** for environment access

## Troubleshooting

- Check `.env.example` for required variables
- Run `npm run config:validate` to verify setup
- Ensure environment-specific variables are set in `wrangler.toml`
- Verify Cloudflare KV namespaces are created and bound

---

*See [Environment Configuration ADR](../adr/environment-config.md) for architectural decisions.*
