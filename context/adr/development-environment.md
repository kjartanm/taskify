# Development Environment

## Status

Accepted

## Context

The Taskify MVP requires a consistent, efficient development environment that supports SvelteKit, Cloudflare services, and enables smooth collaboration among team members. The environment should minimize setup time and provide essential tools for development, testing, and deployment, while aligning with the established stack and testing strategy.

## Decision

- Use Node.js LTS version (v20+) for development consistency
- Use nvm (Node Version Manager) for managing Node.js versions across team members
- Use npm as package manager for dependency management (aligning with code quality tooling)
- Set up local development with Wrangler CLI for Cloudflare services integration
- Use TypeScript for type safety and better developer experience (supporting ESLint configuration)
- Configure hot reload and auto-refresh for efficient development cycles
- Set up local SQLite database for development using Cloudflare D1 local mode
- Implement three-tier environment strategy (development → staging → production) for consistent deployment pipeline and testing workflow
- Integrate with established testing frameworks (Vitest, Cucumber.js, Svelte Testing Library, MSW) for comprehensive testing support
- Support code quality tools (ESLint, Prettier, Husky, EditorConfig, lint-staged) in development workflow
- Configure development environment to support Svelte 5 and runes as per stack decisions

## Consequences

Developers will have a consistent environment that closely mirrors production and integrates seamlessly with the established stack (SvelteKit with Svelte 5, Cloudflare services) and testing frameworks (Vitest, Cucumber.js, Svelte Testing Library, MSW). The setup will require initial configuration but will improve development velocity and reduce environment-related issues. TypeScript adds compile-time safety but requires additional setup complexity, which is offset by improved integration with code quality tools (ESLint, Prettier, Husky, EditorConfig). The three-tier environment strategy ensures safe code progression from development through staging to production, reducing deployment risks and enabling thorough testing at each stage. Integration with CI/CD pipeline provides automated testing and deployment capabilities through GitHub Actions.

## Urls

- [Node.js Official Documentation](https://nodejs.org/docs/)
- [nvm Documentation](https://github.com/nvm-sh/nvm)
- [npm Documentation](https://docs.npmjs.com/)
- [Wrangler CLI Documentation](https://developers.cloudflare.com/workers/wrangler/)
- [TypeScript Documentation](https://www.typescriptlang.org/docs/)
- [SvelteKit Documentation](https://kit.svelte.dev/docs)
- [Cloudflare D1 Local Development](https://developers.cloudflare.com/d1/best-practices/local-development/)
- [Environment Strategy Documentation](../docs/environment-strategy.md)
