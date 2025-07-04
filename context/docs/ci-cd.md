# CI/CD Pipeline Documentation

## Overview

The Taskify MVP uses GitHub Actions for automated CI/CD pipeline with deployment to Cloudflare Pages. The pipeline ensures code quality, runs comprehensive tests, and deploys safely across environments.

## Pipeline Stages

### 1. Code Quality Checks
- **ESLint**: Code linting and error detection
- **Prettier**: Code formatting validation
- **TypeScript**: Type checking and compilation
- **Triggers**: Every push and pull request

### 2. Testing
- **Unit Tests**: Vitest with 80% coverage requirement
- **Component Tests**: Svelte Testing Library
- **E2E Tests**: Cucumber.js with Puppeteer (headless mode in CI)
- **Triggers**: Every push and pull request

### 3. Security Scanning
- **npm audit**: Dependency vulnerability checks
- **CodeQL**: Static code analysis
- **Triggers**: Every push and pull request

### 4. Deployment
- **Staging**: Automatic on pull requests (preview deployments)
- **Production**: Automatic on main branch merges
- **Platform**: Cloudflare Pages

## Commands

### Local Development
```bash
# Run all quality checks
npm run ci:quality

# Run all tests
npm run ci:test

# Full CI build locally
npm run ci:build

# E2E tests
npm run test:e2e:headless
```

### Database Operations
```bash
# Local migrations
npm run db:migrate

# Staging migrations
npm run db:migrate:staging

# Production migrations (use with caution)
npm run db:migrate:production
```

## Environment Configuration

### Required GitHub Secrets
- `CLOUDFLARE_API_TOKEN`: Cloudflare API token
- `CLOUDFLARE_ACCOUNT_ID`: Cloudflare account ID
- `CLOUDFLARE_PROJECT_NAME`: Cloudflare Pages project name

### Environment Variables
- **Development**: `.env` file (local)
- **Staging**: Cloudflare KV + Wrangler secrets
- **Production**: Cloudflare KV + Wrangler secrets

## Workflow Triggers

### Pull Request Workflow
```
PR Created → Code Quality → Tests → Security → Staging Deploy → Preview URL
```

### Main Branch Workflow
```
Merge to Main → Code Quality → Tests → Security → Production Deploy → Health Checks
```

## Rollback Process

### Automatic Rollback
- Triggered on deployment health check failures
- Reverts to previous successful deployment
- Notifications sent to team

### Manual Rollback
```bash
# Via Cloudflare Pages dashboard
# Or via Wrangler CLI
wrangler pages deployment list
wrangler pages deployment rollback <deployment-id>
```

## Monitoring

### CI/CD Metrics
- **Build Time**: Target < 10 minutes
- **Test Coverage**: Minimum 80%
- **Deployment Success Rate**: Target > 95%

### Health Checks
- **Staging**: Basic functionality verification
- **Production**: Comprehensive health checks
- **Rollback Trigger**: Any health check failure

## Troubleshooting

### Common Issues

#### Build Failures
1. Check dependency versions in package.json
2. Verify Node.js version (requires v20+)
3. Check TypeScript compilation errors

#### Test Failures
1. Run tests locally: `npm run ci:test`
2. Check test coverage: `npm run test:coverage`
3. Debug E2E tests: `npm run test:e2e` (non-headless)

#### Deployment Failures
1. Verify Cloudflare credentials
2. Check build artifacts
3. Review deployment logs in GitHub Actions

### Quick Fixes
```bash
# Fix linting issues
npm run lint:fix

# Clear node_modules and reinstall
rm -rf node_modules package-lock.json
npm install

# Reset local database
npm run db:migrate
```

## Pipeline Configuration Files

- **`.github/workflows/ci-cd.yml`**: Main pipeline configuration
- **`vitest.config.ts`**: Unit test configuration
- **`vitest.config.component.ts`**: Component test configuration
- **`cucumber.config.js`**: E2E test configuration
- **`wrangler.toml`**: Cloudflare deployment configuration

## Best Practices

### Development
1. Run `npm run ci:quality` before pushing
2. Ensure tests pass locally: `npm run ci:test`
3. Use feature branches for all changes
4. Write meaningful commit messages

### Deployment
1. Test in staging before production
2. Monitor deployment health checks
3. Keep rollback procedure accessible
4. Document any manual deployment steps

### Security
1. Never commit secrets to repository
2. Use Wrangler secrets for sensitive data
3. Regularly update dependencies
4. Review security scan results

## Related Documentation

- [Environment Strategy](environment-strategy.md)
- [CI/CD Pipeline ADR](../adr/ci-cd-pipeline.md)
- [Testing Strategy ADR](../adr/testing-strategy.md)
- [Code Quality ADR](../adr/code-quality.md)
