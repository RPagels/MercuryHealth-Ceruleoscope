// The following will create an Azure Function app on
// a consumption plan, along with a storage account
param location string = resourceGroup().location
param functionAppName string
param functionAppServicePlanName string
param appInsightsInstrumentationKey string
param appInsightsConnectionString string
param defaultTags object

//param ftpsState string = 'FtpsOnly'
param linuxFxVersion string = 'NODE|16' // 'php|7.4'
param sku string = 'S1'
//param skuCode string = 'Y1'
param functionRuntime string = 'node'
param functionExtensionVersion string = '~4'

// remove dashes for storage account name
var storageAccountName = 'sta${uniqueString(resourceGroup().id)}'

// Storage Account
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  tags: {}
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
    accessTier: 'Hot'
    minimumTlsVersion: 'TLS1_2'
  }
}

// App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: functionAppServicePlanName
  location: location
  tags: defaultTags
  sku: {
    name: sku
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

// Function App
resource appService 'Microsoft.Web/sites@2022-03-01' = {
  name: functionAppName
  location: location
  tags: defaultTags
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    httpsOnly: true
    serverFarmId: appServicePlan.id
    clientAffinityEnabled: true
    reserved: true
    siteConfig: {
      alwaysOn: true
      linuxFxVersion: linuxFxVersion
      appSettings: [
        {
          name: 'PLAYWRIGHT_BROWSERS_PATH'
          value: 'home/site/wwwroot/node_modules/playwright-chromium/.local-browsers/'
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'
        }
        {
          name: 'WebsiteContentAzureFileConnectionString'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsightsInstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsightsConnectionString //'InstrumentationKey=${appInsightsInstrumentationKey}'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: functionRuntime
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: functionExtensionVersion
        }
        {
          name: 'LOCATION'
          value: 'us-va-ash-azr' // East US, https://docs.microsoft.com/en-us/azure/azure-monitor/app/monitor-web-app-availability
        }  
        {
          name: 'TESTNAME'
          value: 'Playwright Tests'
        }  
      ]
    }
    
  }
  
}

// Function App Config
// resource functionAppConfig 'Microsoft.Web/sites/config@2021-03-01' = {
//   parent: functionApp
//   name: 'web'
//   properties: {
//     numberOfWorkers: -1
//     defaultDocuments: [
//       'Default.htm'
//       'Default.html'
//       'Default.asp'
//       'index.htm'
//       'index.html'
//       'iisstart.htm'
//       'default.aspx'
//       'index.php'
//       'hostingstart.html'
//     ]
//     netFrameworkVersion: 'v4.0'
//     phpVersion: '5.6'
//     requestTracingEnabled: false
//     remoteDebuggingEnabled: false
//     httpLoggingEnabled: false
//     logsDirectorySizeLimit: 35
//     detailedErrorLoggingEnabled: false
//     publishingUsername: '$${functionAppName}'
//     scmType: 'None'
//     use32BitWorkerProcess: true
//     webSocketsEnabled: false
//     alwaysOn: false
//     managedPipelineMode: 'Integrated'
//     virtualApplications: [
//       {
//         virtualPath: '/'
//         physicalPath: 'site\\wwwroot'
//         preloadEnabled: true
//       }
//     ]
//     loadBalancing: 'LeastRequests'
//     experiments: {
//       rampUpRules: []
//     }
//     autoHealEnabled: false
//     cors: {
//       allowedOrigins: [
//         'https://functions.azure.com'
//         'https://functions-staging.azure.com'
//         'https://functions-next.azure.com'
//       ]
//       supportCredentials: false
//     }
//     localMySqlEnabled: false
//     ipSecurityRestrictions: [
//       {
//         ipAddress: 'Any'
//         action: 'Allow'
//         priority: 1
//         name: 'Allow all'
//         description: 'Allow all access'
//       }
//     ]
//     scmIpSecurityRestrictions: [
//       {
//         ipAddress: 'Any'
//         action: 'Allow'
//         priority: 1
//         name: 'Allow all'
//         description: 'Allow all access'
//       }
//     ]
//     scmIpSecurityRestrictionsUseMain: false
//     http20Enabled: true
//     minTlsVersion: '1.2'
//     ftpsState: 'AllAllowed'
//     preWarmedInstanceCount: 0
//   }
// }

