const { test, expect } = require("ceruleoscope");

test('Test-Navigation', async ({ page }) => {
  // Go to https://app-fq3ruuhxgjony.azurewebsites.net/
  await page.goto('https://app-fq3ruuhxgjony.azurewebsites.net/');
  expect(await page.title()).toBe('Home Page - Mercury Health');
  // Click #menu_nutrition
  await page.locator('#menu_nutrition').click();
  await page.waitForURL('https://app-fq3ruuhxgjony.azurewebsites.net/Nutritions');
  // Click #button_details_25
  await page.locator('#button_details_25').click();
  await page.waitForURL('https://app-fq3ruuhxgjony.azurewebsites.net/Nutritions/Details/25');
  // Click text=Back to List
  await page.locator('text=Back to List').click();
  await page.waitForURL('https://app-fq3ruuhxgjony.azurewebsites.net/Nutritions');
  // Click text=Exercises
  await page.locator('text=Exercises').click();
  await page.waitForURL('https://app-fq3ruuhxgjony.azurewebsites.net/Exercises');
  // Click #button_details_25
  await page.locator('#button_details_25').click();
  await page.waitForURL('https://app-fq3ruuhxgjony.azurewebsites.net/Exercises/Details/25');
  // Click text=Back to List
  await page.locator('text=Back to List').click();
  await page.waitForURL('https://app-fq3ruuhxgjony.azurewebsites.net/Exercises');
  // Click #menu_privacy
  await page.locator('#menu_privacy').click();
  await page.waitForURL('https://app-fq3ruuhxgjony.azurewebsites.net/Home/Privacy');
  // Go to https://app-fq3ruuhxgjony.azurewebsites.net/
  await page.goto('https://app-fq3ruuhxgjony.azurewebsites.net/');
});

test('Test-Nutrition Edit', async ({ page }) => {
  // Go to https://app-fq3ruuhxgjony.azurewebsites.net/
  await page.goto('https://app-fq3ruuhxgjony.azurewebsites.net/');
  expect(await page.title()).toBe('Home Page - Mercury Health');
  // Click #menu_nutrition
  await page.locator('#menu_nutrition').click();
  await expect(page).toHaveURL('https://app-fq3ruuhxgjony.azurewebsites.net/Nutritions');
  // Click #button_edit_25
  await page.locator('#button_edit_25').click();
  await expect(page).toHaveURL('https://app-fq3ruuhxgjony.azurewebsites.net/Nutritions/Edit/25');
  // Click text=Save
  await page.locator('text=Save').click();
  await expect(page).toHaveURL('https://app-fq3ruuhxgjony.azurewebsites.net/Nutritions');
  // Go to https://app-fq3ruuhxgjony.azurewebsites.net/
  await page.goto('https://app-fq3ruuhxgjony.azurewebsites.net/');
});

test('Test-Exercises Edit', async ({ page }) => {
  // Go to https://app-fq3ruuhxgjony.azurewebsites.net/
  await page.goto('https://app-fq3ruuhxgjony.azurewebsites.net/');
  
  // Click text=Exercises
  await page.locator('text=Exercises').click();
  await expect(page).toHaveURL('https://app-fq3ruuhxgjony.azurewebsites.net/Exercises');
  
  // Exercises - Mercury Health
  expect(await page.title()).toBe('Exercise - Mercury Health');

  // Click #button_edit_25
  await page.locator('#button_edit_25').click();
  await expect(page).toHaveURL('https://app-fq3ruuhxgjony.azurewebsites.net/Exercises/Edit/25');
  // Click text=Save
  await page.locator('text=Save').click();
  await expect(page).toHaveURL('https://app-fq3ruuhxgjony.azurewebsites.net/Exercises');
  // Go to https://app-fq3ruuhxgjony.azurewebsites.net/
  await page.goto('https://app-fq3ruuhxgjony.azurewebsites.net/');
});

// test('Test-Offline', async ({ page }) => {
//   await page.goto('http://www.webappoffline.net/');
//   expect(await page.title()).toBe('Example Title');

//     const browser = await playwright.chromium.launch();
//     const page = await browser.newPage();
//     await page.goto('https://native-land.ca/');
//     await page.screenshot({ path: 'example.png' });
  
//     await browser.close();
//   });

// test('test2', async ({ page }) => {
//   // Go to https://www.bing.com/?toWww=1&redig=05F89874A9C54F26869C61B368E2D94F
//   await page.goto('https://www.bing.com/?toWww=1&redig=05F89874A9C54F26869C61B368E2D94F');
//   // Click text=Images
//   await page.click('text=Images');
//   await expect(page).toHaveURL('https://www.bing.com/images/trending?form=Z9LH');
//   // Click [aria-label="Enter your search here - Search suggestions will show as you type"]
//   await page.click('[aria-label="Enter your search here - Search suggestions will show as you type"]');
//   // Fill [aria-label="Enter your search here - Search suggestions will show as you type"]
//   await page.fill('[aria-label="Enter your search here - Search suggestions will show as you type"]', 'puppi');
//   // Click text=and kittens
//   await Promise.all([
//     page.waitForNavigation(/*{ url: 'https://www.bing.com/images/search?q=puppies+and+kittens&qs=MM&form=QBILPG&sp=2&ghc=1&pq=puppies&sk=LS1&sc=8-7&cvid=F0E5E192AE6D4B8CBC6E7B9A48C2C62C&first=1&tsc=ImageBasicHover' }*/),
//     page.click('text=and kittens')
//   ]);
// });