module.exports = {
  default: {
    require: ['ts-node/register'],
    requireModule: ['tsconfig-paths/register'],
    format: ['progress-bar', 'html:src/test/reports/cucumber-staging-report.html'],
    formatOptions: {
      snippetInterface: 'async-await'
    },
    paths: ['context/features/**/*.feature'],
    require: ['src/test/step-definitions/**/*.ts'],
    worldParameters: {
      headless: true,
      slowMo: 50,
      baseUrl: 'https://staging.taskify.club',
      environment: 'staging'
    }
  },
  headless: {
    require: ['ts-node/register'],
    requireModule: ['tsconfig-paths/register'],
    format: ['progress-bar', 'html:src/test/reports/cucumber-staging-report.html'],
    formatOptions: {
      snippetInterface: 'async-await'
    },
    paths: ['context/features/**/*.feature'],
    require: ['src/test/step-definitions/**/*.ts'],
    worldParameters: {
      headless: true,
      slowMo: 0,
      baseUrl: 'https://staging.taskify.club',
      environment: 'staging'
    }
  }
};
