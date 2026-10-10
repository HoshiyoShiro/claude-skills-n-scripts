// Shared Playwright helpers for the QA and UX skills. Copy next to your run scripts.
import { chromium, devices } from 'playwright';
import fs from 'node:fs';
import path from 'node:path';

// launch({ device: 'desktop' | 'phone' | '<Playwright device name>', headless, slowMo, executablePath, channel })
// Returns { browser, context, page }.
export async function launch(opts = {}) {
  const { device = 'desktop', headless = false, slowMo = 150, executablePath, channel } = opts;
  const browser = await chromium.launch({ headless, slowMo, executablePath, channel });
  let contextOpts = { ignoreHTTPSErrors: true, viewport: { width: 1440, height: 900 } };
  if (device === 'phone') {
    contextOpts = { ignoreHTTPSErrors: true, viewport: { width: 390, height: 844 }, isMobile: true, hasTouch: true, deviceScaleFactor: 2 };
  } else if (device !== 'desktop') {
    if (!devices[device]) throw new Error(`unknown device: ${device}`);
    contextOpts = { ...devices[device], ignoreHTTPSErrors: true };
  }
  const context = await browser.newContext(contextOpts);
  const page = await context.newPage();
  return { browser, context, page };
}

// attachEvidence(page, log): pushes console errors, page errors and HTTP >= 400 responses into log.
export function attachEvidence(page, log = { console: [], pageErrors: [], http: [] }) {
  page.on('console', m => { if (m.type() === 'error') log.console.push(m.text()); });
  page.on('pageerror', e => log.pageErrors.push(String(e)));
  page.on('response', r => {
    if (r.status() >= 400) log.http.push(`${r.request().method()} ${r.url()} ${r.status()}`);
  });
  return log;
}

// shot(page, dir, name): saves a full-page screenshot and returns its path.
export async function shot(page, dir, name) {
  fs.mkdirSync(dir, { recursive: true });
  const file = path.join(dir, `${name.replace(/[^\w.-]+/g, '_')}.png`);
  await page.screenshot({ path: file, fullPage: true });
  return file;
}

// creds(role): reads the accounts file named in ACCOUNTS_FILE and returns { username, password, extra } without printing.
export function creds(role) {
  const file = process.env.ACCOUNTS_FILE;
  if (!file) throw new Error('set ACCOUNTS_FILE to the accounts file path');
  const a = JSON.parse(fs.readFileSync(file, 'utf8')).accounts.find(x => x.role === role);
  if (!a) throw new Error(`no account for role: ${role}`);
  return { username: a.username, password: a.password, extra: a.extraLoginFields || {} };
}
