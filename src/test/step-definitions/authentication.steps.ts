import { Given, When, Then } from '@cucumber/cucumber';
import { expect } from 'vitest';
import './browser-setup'; // Import browser setup

Given('I am on the login page', async function () {
  // Navigate to login page
  await this.page.goto(`${process.env.VITE_API_BASE_URL || 'http://localhost:3000'}/login`);
});

When('I enter valid credentials', async function () {
  // Enter valid username and password
  await this.page.type('#username', 'valid@example.com');
  await this.page.type('#password', 'validPassword123');
});

When('I enter invalid credentials', async function () {
  // Enter invalid username and password
  await this.page.type('#username', 'invalid@example.com');
  await this.page.type('#password', 'wrongPassword');
});

When('I click the login button', async function () {
  // Click the login button
  await this.page.click('#login-button');
  await this.page.waitForNavigation({ waitUntil: 'networkidle0' });
});

Then('I should be redirected to the dashboard', async function () {
  // Check if redirected to dashboard
  const url = this.page.url();
  expect(url).toContain('/dashboard');
});

Then('I should see a welcome message', async function () {
  // Check for welcome message
  const welcomeMessage = await this.page.$eval('#welcome-message', el => el.textContent);
  expect(welcomeMessage).toBeTruthy();
});

Then('I should see an error message', async function () {
  // Check for error message
  const errorMessage = await this.page.$eval('#error-message', el => el.textContent);
  expect(errorMessage).toBeTruthy();
});

Then('I should remain on the login page', async function () {
  // Check if still on login page
  const url = this.page.url();
  expect(url).toContain('/login');
});

When('I click the "Forgot Password" link', async function () {
  // Click forgot password link
  await this.page.click('#forgot-password-link');
  await this.page.waitForNavigation({ waitUntil: 'networkidle0' });
});

Then('I should be redirected to the password reset page', async function () {
  // Check if redirected to password reset page
  const url = this.page.url();
  expect(url).toContain('/password-reset');
});

Then('I should be able to enter my email address', async function () {
  // Check if email input is present
  const emailInput = await this.page.$('#email');
  expect(emailInput).toBeTruthy();
});
