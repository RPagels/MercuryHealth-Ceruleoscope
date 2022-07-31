module.exports = async function (context, myTimer) {
    try{
        const { PlaywrightTestLauncher } = require("ceruleoscope");
        let responseMessage = await PlaywrightTestLauncher.Run();
        context.log("Playwright tests console output: " + responseMessage);
    } catch(ex){
        context.log("Failed to run Playwright tests: " + ex);
    }
};
