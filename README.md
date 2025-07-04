# Taskify

[![GitHub Repository](https://img.shields.io/badge/GitHub-kjartanm%2Ftaskify-blue?logo=github)](https://github.com/kjartanm/taskify)

A web application for effective task management designed for kids between 10-15 years old. Think of it as a "Junior Trello" - easy, user-friendly, and attractive, while still being flexible enough to handle typical school activities, sports, hobbies, and daily routines.

## 🎯 Key Features

- **Parent-controlled accounts**: Children's accounts can only be created by parents
- **Multi-child management**: Parents can manage accounts for multiple children
- **Flexible task lists**: Kids can have several task lists for different purposes
- **Smart deadlines**: Tasks with date/time deadlines and notifications
- **Dual view modes**: Switch between list view and kanban view
- **Repeatable checklists**: Convert task lists into repeatable checklists with configurable frequency
- **Gamification**: Task completion is gamified with badges and points
- **Reward system**: Parents can award badges and set up point-based reward exchanges

## 🚀 Quick Start

### Prerequisites
- Node.js LTS (v20+)
- npm package manager
- Git

### Development Setup
```bash
# Install dependencies
npm install

# Set up local database
npm run db:setup

# Start development server
npm run dev
```

Visit [http://localhost:5173](http://localhost:5173) to see the application.

## 📚 Documentation

### Architecture & Decisions
- **[Architecture Decision Records (ADRs)](context/adr/)** - All architectural decisions and their rationale
- **[Stack Decision](context/adr/stack.md)** - Technology stack choices (SvelteKit, Cloudflare, etc.)
- **[Feature Requirements](context/adr/feature-requirements.md)** - Feature documentation approach

### Development
- **[Development Environment Setup](context/docs/dev-environment.md)** - Complete setup instructions
- **[Environment Strategy](context/docs/environment-strategy.md)** - Development, staging, and production environments
- **[Database Documentation](context/docs/database.md)** - Database schema and migration guide
- **[Configuration Management](context/docs/config-management.md)** - Environment variables and configuration

### Testing & Quality
- **[Testing Guide](context/docs/testing.md)** - Testing strategy and how to run tests
- **[CI/CD Documentation](context/docs/ci-cd.md)** - Continuous integration and deployment pipeline

### Project Planning
- **[MVP Plan](context/app/mvp-plan.md)** - Minimum viable product roadmap
- **[Project Risks](context/app/risks.md)** - Identified risks and mitigation strategies

## 🧪 Testing

```bash
# Run all tests
npm run test:all

# Run unit tests
npm run test

# Run component tests
npm run test:component

# Run E2E tests
npm run test:e2e

# Run with coverage
npm run test:coverage
```

## 🏗️ Tech Stack

- **Frontend**: SvelteKit with Svelte 5 + Runes
- **Styling**: Tailwind CSS + DaisyUI
- **Database**: Cloudflare D1 (SQLite)
- **Deployment**: Cloudflare Pages
- **Testing**: Vitest, Cucumber.js, Svelte Testing Library
- **Code Quality**: ESLint, Prettier, Husky

## 📁 Project Structure

```
├── context/                    # Project documentation and context
│   ├── adr/                   # Architecture Decision Records
│   ├── docs/                  # Technical documentation
│   ├── features/              # Gherkin feature files
│   ├── data/                  # Database schemas and sample data
│   └── app/                   # Project planning documents
├── src/                       # Source code
│   ├── lib/                   # Shared libraries and components
│   ├── routes/                # SvelteKit routes
│   └── test/                  # Test utilities and fixtures
├── migrations/                # Database migrations
└── static/                    # Static assets
```

## 🔧 Available Scripts

### Development
- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run preview` - Preview production build

### Database
- `npm run db:setup` - Initialize database with migrations and seed data
- `npm run db:migrate` - Run database migrations
- `npm run db:seed` - Seed database with sample data
- `npm run db:studio` - Open Drizzle Studio

### Testing
- `npm run test` - Run unit tests
- `npm run test:e2e` - Run E2E tests
- `npm run test:coverage` - Run tests with coverage
- `npm run test:all` - Run all tests

### Code Quality
- `npm run lint` - Run ESLint
- `npm run format` - Format code with Prettier
- `npm run check` - Run Svelte type checking

### Deployment
- `npm run wrangler:deploy` - Deploy to production
- `npm run wrangler:deploy:staging` - Deploy to staging

## 🌍 Environments

The project uses a three-tier environment strategy:

1. **Development** - Local development with hot reload
2. **Staging** - Pre-production testing environment
3. **Production** - Live application

See [Environment Strategy](context/docs/environment-strategy.md) for detailed configuration.

## 🤝 Contributing

This project is hosted on GitHub at [kjartanm/taskify](https://github.com/kjartanm/taskify).

1. Read the [Development Environment Setup](context/docs/dev-environment.md)
2. Review the [Architecture Decision Records](context/adr/) to understand project decisions
3. Follow the testing guidelines in [Testing Documentation](context/docs/testing.md)
4. Ensure code quality with `npm run ci:quality` before submitting

To contribute:
1. Fork the repository
2. Create a feature branch from `main`
3. Make your changes following the project guidelines
4. Run tests and quality checks
5. Submit a pull request

## 📄 License

This project is private and proprietary.

---

For more detailed information, explore the documentation in the `context/` directory or check the specific guides linked above.
