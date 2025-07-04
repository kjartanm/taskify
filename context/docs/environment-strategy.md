# Environment Strategy

## Overview

The Taskify MVP implements a three-tier environment strategy to ensure safe, reliable, and consistent deployment of features from development through to production. This document outlines the complete environment strategy, including setup, configuration, and deployment workflows.

## Three-Tier Environment Architecture

### 1. Development Environment

**Purpose**: Local development and feature implementation

**Infrastructure**:
- **Runtime**: Node.js LTS (v20+) with nvm for version management
- **Database**: Cloudflare D1 local mode using Wrangler CLI
- **Configuration**: Environment variables via `.env` files
- **Storage**: Local file system and Cloudflare KV local mode
- **Build**: Local SvelteKit development server with hot reload

**Key Characteristics**:
- Runs entirely on developer's local machine
- Uses Wrangler CLI for Cloudflare services simulation
- Supports offline development
- Individual developer databases (isolated)
- Fast iteration cycles with hot reload

**Configuration**:
```bash
# .env.development
NODE_ENV=development
DATABASE_URL=local
KV_NAMESPACE=dev-local
API_BASE_URL=http://localhost:5173
```

### 2. Staging Environment

**Purpose**: Pre-production testing, integration testing, and stakeholder review

**Infrastructure**:
- **Platform**: Cloudflare Pages (preview deployments)
- **Database**: Cloudflare D1 staging database
- **Configuration**: Cloudflare KV staging namespace
- **Storage**: Cloudflare KV staging environment
- **Build**: Automated builds via GitHub Actions

**Key Characteristics**:
- Mirrors production infrastructure exactly
- Automatic deployments on pull requests
- Integration and E2E testing execution
- Stakeholder review and approval environment
- Preview URLs for each pull request

**Configuration**:
```bash
# Staging environment variables
NODE_ENV=staging
DATABASE_ID=staging-db-id
KV_NAMESPACE_ID=staging-kv-id
API_BASE_URL=https://staging.taskify.pages.dev
```

### 3. Production Environment

**Purpose**: Live application serving end users

**Infrastructure**:
- **Platform**: Cloudflare Pages (production deployment)
- **Database**: Cloudflare D1 production database
- **Configuration**: Cloudflare KV production namespace
- **Storage**: Cloudflare KV production environment
- **Build**: Automated builds via GitHub Actions on main branch

**Key Characteristics**:
- High availability and performance
- Production-grade security and monitoring
- Automatic deployments from main branch
- Rollback capabilities for failed deployments
- Full monitoring and alerting

**Configuration**:
```bash
# Production environment variables
NODE_ENV=production
DATABASE_ID=production-db-id
KV_NAMESPACE_ID=production-kv-id
API_BASE_URL=https://taskify.pages.dev
```

## Environment Workflow

### Development Phase
```
Developer → Local Development → Feature Branch → Pull Request
```

1. **Local Development**: Developer implements features locally
2. **Feature Branch**: Code pushed to feature branch
3. **Pull Request**: Creates staging deployment for review

### Staging Phase
```
Pull Request → Staging Deployment → Testing → Review → Approval
```

1. **Automatic Deployment**: PR triggers staging deployment
2. **Automated Testing**: CI/CD runs all test suites
3. **Manual Testing**: QA and stakeholder review
4. **Approval**: PR approved for merge

### Production Phase
```
Main Branch Merge → Production Deployment → Monitoring
```

1. **Automatic Deployment**: Main branch triggers production deployment
2. **Health Checks**: Automated verification of deployment success
3. **Monitoring**: Continuous monitoring and alerting

## Configuration Management

### Environment Variables

Each environment uses specific configuration variables managed through different systems:

#### Development
- **Method**: `.env` files and environment variables
- **Storage**: Local file system
- **Management**: Individual developer responsibility

#### Staging
- **Method**: Cloudflare KV and Wrangler secrets
- **Storage**: Cloudflare KV staging namespace
- **Management**: CI/CD pipeline and manual configuration

#### Production
- **Method**: Cloudflare KV and Wrangler secrets
- **Storage**: Cloudflare KV production namespace
- **Management**: CI/CD pipeline and infrastructure team

### Configuration Validation

All environments implement configuration validation at startup:

```javascript
// config/validation.js
export function validateEnvironmentConfig() {
  const required = [
    'NODE_ENV',
    'DATABASE_ID',
    'KV_NAMESPACE_ID',
    'API_BASE_URL'
  ];
  
  for (const key of required) {
    if (!process.env[key]) {
      throw new Error(`Missing required environment variable: ${key}`);
    }
  }
}
```

## Database Strategy

### Development Database
- **Type**: SQLite local file via Wrangler D1 local mode
- **Command**: `wrangler d1 migrations apply --local`
- **Data**: Sample data for development and testing
- **Isolation**: Individual developer databases

### Staging Database
- **Type**: Cloudflare D1 staging instance
- **Command**: `wrangler d1 migrations apply --env staging`
- **Data**: Production-like data for testing
- **Sharing**: Shared across team for integration testing

### Production Database
- **Type**: Cloudflare D1 production instance
- **Command**: `wrangler d1 migrations apply --env production`
- **Data**: Live user data
- **Access**: Restricted to automated deployments and authorized personnel

## Testing Strategy per Environment

### Development Environment Testing
- **Unit Tests**: Vitest test runner
- **Component Tests**: Svelte Testing Library
- **Integration Tests**: Local API testing
- **Coverage**: Minimum 80% code coverage

### Staging Environment Testing
- **Integration Tests**: Full API integration testing
- **End-to-End Tests**: Cucumber.js with Puppeteer
- **Performance Tests**: Load testing on staging infrastructure
- **Security Tests**: Automated security scanning

### Production Environment Testing
- **Health Checks**: Automated deployment verification
- **Monitoring**: Continuous performance monitoring
- **Rollback Tests**: Automated rollback capability verification
- **User Acceptance**: Real user monitoring and feedback

## Security Considerations

### Environment Isolation
- **Network**: Separate network namespaces for each environment
- **Data**: Isolated databases with no cross-environment access
- **Secrets**: Environment-specific secret management
- **Access**: Role-based access control per environment

### Secret Management
- **Development**: Local `.env` files (not committed to git)
- **Staging**: Wrangler secrets with staging scope
- **Production**: Wrangler secrets with production scope
- **Rotation**: Regular secret rotation for production

## Monitoring and Alerting

### Development Environment
- **Logs**: Local console logging
- **Errors**: Browser developer tools
- **Performance**: Local development metrics

### Staging Environment
- **Logs**: Cloudflare Pages deployment logs
- **Errors**: Automated error reporting
- **Performance**: Staging performance metrics
- **Notifications**: Team notifications for test failures

### Production Environment
- **Logs**: Cloudflare Analytics and Real User Monitoring
- **Errors**: Production error tracking and alerting
- **Performance**: Real-time performance monitoring
- **Notifications**: Immediate alerts for critical issues

## Deployment Rollback Strategy

### Staging Rollback
- **Method**: Redeploy previous successful staging deployment
- **Trigger**: Manual or automated on test failure
- **Impact**: Minimal (affects only staging environment)

### Production Rollback
- **Method**: Cloudflare Pages rollback to previous deployment
- **Trigger**: Automated on health check failure or manual
- **Impact**: Critical (affects live users)
- **SLA**: Rollback within 5 minutes of issue detection

## Environment Promotion Process

### Code Promotion Flow
```
Development → Staging → Production
     ↓           ↓         ↓
  Local env  → PR env → Main branch
```

### Data Promotion Flow
- **Development**: Sample/test data only
- **Staging**: Production-like data (anonymized)
- **Production**: Live user data

### Configuration Promotion
- **Manual Review**: All configuration changes reviewed
- **Automated Testing**: Configuration validation in CI/CD
- **Staged Rollout**: Configuration changes deployed to staging first

## Troubleshooting Guide

### Common Issues

#### Development Environment
- **Issue**: Wrangler CLI not connecting to local D1
- **Solution**: Ensure Wrangler is logged in and using correct project

#### Staging Environment
- **Issue**: Staging deployment failing
- **Solution**: Check GitHub Actions logs and Cloudflare deployment status

#### Production Environment
- **Issue**: Production deployment slow or failing
- **Solution**: Check Cloudflare status and initiate rollback if necessary

### Contact Information
- **Development Issues**: Development team lead
- **Staging Issues**: CI/CD pipeline maintainer
- **Production Issues**: Infrastructure team (24/7 support)

## Best Practices

### General
1. **Environment Parity**: Keep environments as similar as possible
2. **Configuration as Code**: All configuration stored in version control
3. **Automated Testing**: Comprehensive testing at each stage
4. **Monitoring**: Continuous monitoring and alerting
5. **Documentation**: Keep environment documentation up-to-date

### Development
1. **Local First**: Develop and test locally before pushing
2. **Clean State**: Regularly reset local database to clean state
3. **Environment Variables**: Use `.env.example` templates
4. **Dependency Management**: Keep dependencies synchronized

### Staging
1. **Production Parity**: Staging should mirror production exactly
2. **Test Data**: Use realistic but anonymized test data
3. **Performance Testing**: Regular performance testing on staging
4. **Review Process**: Mandatory review before production deployment

### Production
1. **Change Management**: All changes through proper approval process
2. **Monitoring**: Continuous monitoring and alerting
3. **Backup Strategy**: Regular backups and recovery testing
4. **Security**: Regular security audits and updates

## Related Documentation

- [Development Environment Setup ADR](../adr/development-environment.md)
- [CI/CD Pipeline ADR](../adr/ci-cd-pipeline.md)
- [Environment Configuration ADR](../adr/environment-config.md)
- [Local Database ADR](../adr/local-database.md)
- [Testing Strategy ADR](../adr/testing-strategy.md)
