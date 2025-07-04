# Development Environment Setup

## Prerequisites

- Node.js LTS (v20+) via nvm
- npm package manager
- Git

## Quick Start

1. **Install Node.js**:
   ```bash
   nvm install 20
   nvm use 20
   ```

2. **Install dependencies**:
   ```bash
   npm install
   ```

3. **Setup local development**:
   ```bash
   npm run wrangler:dev
   ```

## Available Scripts

- `npm run dev` - Start development server with hot reload
- `npm run build` - Build for production
- `npm run test` - Run unit tests
- `npm run test:e2e` - Run end-to-end tests
- `npm run lint` - Run ESLint
- `npm run format` - Format code with Prettier
- `npm run db:migrate` - Apply database migrations locally

## Environment Configuration

- **Development**: Local SQLite via Cloudflare D1 local mode
- **Staging**: Cloudflare D1 staging database
- **Production**: Cloudflare D1 production database

## Tools Integrated

- **Testing**: Vitest, Cucumber.js, Svelte Testing Library, MSW
- **Code Quality**: ESLint, Prettier, Husky, lint-staged
- **Build**: SvelteKit with Svelte 5, TypeScript
- **Deployment**: Wrangler CLI, Cloudflare Pages

## Troubleshooting

- Ensure Node.js version matches `.nvmrc` if present
- Run `npm run ci:build` to test full CI pipeline locally
- Check `wrangler.toml` for Cloudflare service configuration

---

*See [Development Environment ADR](../adr/development-environment.md) for architectural decisions.*
