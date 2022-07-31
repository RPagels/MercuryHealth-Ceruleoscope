const config = {
    use: {
        testDir: 'Tests',
        headless: true,
      viewport: { width: 1280, height: 720 },
      ignoreHTTPSErrors: true,
      video: 'on-first-retry',
    },
  };
  
  module.exports = config;