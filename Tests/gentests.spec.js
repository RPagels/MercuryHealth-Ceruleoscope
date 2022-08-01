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

// test('Test-Nutrition Edit', async ({ page }) => {
//   // Go to https://app-fq3ruuhxgjony.azurewebsites.net/
//   await page.goto('https://app-fq3ruuhxgjony.azurewebsites.net/');
//   expect(await page.title()).toBe('Home Page - Mercury Health');
//   // Click #menu_nutrition
//   await page.locator('#menu_nutrition').click();
//   await expect(page).toHaveURL('https://app-fq3ruuhxgjony.azurewebsites.net/Nutritions');
//   // Click #button_edit_25
//   await page.locator('#button_edit_25').click();
//   await expect(page).toHaveURL('https://app-fq3ruuhxgjony.azurewebsites.net/Nutritions/Edit/25');
//   // Click text=Save
//   await page.locator('text=Save').click();
//   await expect(page).toHaveURL('https://app-fq3ruuhxgjony.azurewebsites.net/Nutritions');
//   // Go to https://app-fq3ruuhxgjony.azurewebsites.net/
//   await page.goto('https://app-fq3ruuhxgjony.azurewebsites.net/');
// });

// test('Test-Exercises Edit', async ({ page }) => {
//   // Go to https://app-fq3ruuhxgjony.azurewebsites.net/
//   await page.goto('https://app-fq3ruuhxgjony.azurewebsites.net/');
  
//   // Click text=Exercises
//   await page.locator('text=Exercises').click();
//   await expect(page).toHaveURL('https://app-fq3ruuhxgjony.azurewebsites.net/Exercises');
  
//   // Exercises - Mercury Health
//   expect(await page.title()).toBe('Exercise - Mercury Health');

//   // Click #button_edit_25
//   await page.locator('#button_edit_25').click();
//   await expect(page).toHaveURL('https://app-fq3ruuhxgjony.azurewebsites.net/Exercises/Edit/25');
//   // Click text=Save
//   await page.locator('text=Save').click();
//   await expect(page).toHaveURL('https://app-fq3ruuhxgjony.azurewebsites.net/Exercises');
//   // Go to https://app-fq3ruuhxgjony.azurewebsites.net/
//   await page.goto('https://app-fq3ruuhxgjony.azurewebsites.net/');
// });
