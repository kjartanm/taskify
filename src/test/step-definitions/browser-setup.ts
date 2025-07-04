import { Browser, Page } from 'puppeteer';
import puppeteer from 'puppeteer';
import { Before, After, BeforeAll, AfterAll } from '@cucumber/cucumber';

let browser: Browser;
let page: Page;

// Browser setup for E2E tests
BeforeAll(async function () {
  // Launch browser with appropriate options
  const slowMo = typeof this.parameters.slowMo === 'number' ? this.parameters.slowMo : 0;
  browser = await puppeteer.launch({
    headless: this.parameters.headless !== false,
    slowMo,
    args: [
      '--no-sandbox',
      '--disable-setuid-sandbox',
      '--disable-dev-shm-usage',
      '--disable-accelerated-2d-canvas',
      '--disable-gpu',
      '--window-size=1920,1080',
    ],
  });
});

Before(async function () {
  // Create new page for each scenario
  page = await browser.newPage();
  
  // Set viewport size
  await page.setViewport({
    width: 1920,
    height: 1080,
  });
  
  // Set user agent
  await page.setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36');
  
  // Enable console logs in tests
  page.on('console', (msg) => {
    console.log('PAGE LOG:', msg.text());
  });
  
  // Handle page errors
  page.on('pageerror', (err) => {
    console.error('PAGE ERROR:', err.message);
  });
  
  // Handle failed requests
  page.on('requestfailed', (req) => {
    console.error('REQUEST FAILED:', req.url(), req.failure()?.errorText);
  });
  
  // Store page instance in world context
  this.page = page;
  this.browser = browser;
});

After(async function () {
  // Close page after each scenario
  if (page) {
    await page.close();
  }
});

AfterAll(async function () {
  // Close browser after all tests
  if (browser) {
    await browser.close();
  }
});

// Export for use in step definitions
export { browser, page };
