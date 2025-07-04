module.exports = {
  default: {
    requireModule: ['ts-node/register', 'tsconfig-paths/register'],
    format: ['progress-bar', 'html:src/test/reports/cucumber-report.html'],
    formatOptions: {
      snippetInterface: 'async-await'
    },
    paths: ['context/features/**/*.feature'],
    require: ['src/test/step-definitions/**/*.ts'],
    worldParameters: {
      headless: false,
      slowMo: 100
    }
  },
  headless: {
    requireModule: ['ts-node/register', 'tsconfig-paths/register'],
    format: ['progress-bar', 'html:src/test/reports/cucumber-report.html'],
    formatOptions: {
      snippetInterface: 'async-await'
    },
    paths: ['context/features/**/*.feature'],
    require: ['src/test/step-definitions/**/*.ts'],
    worldParameters: {
      headless: true,
      slowMo: 0
    }
  }
};
