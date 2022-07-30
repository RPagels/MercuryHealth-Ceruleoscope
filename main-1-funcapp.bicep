// The following will create an Azure Function app on
// a consumption plan, along with a storage account
param location string = resourceGroup().location
param functionAppName string
param functionAppServiceName string
param appInsightsInstrumentationKey string
param appInsightsConnectionString string
param defaultTags object

param ftpsState string = 'FtpsOnly'
param linuxFxVersion string = 'Node|16'
param sku string = 'Dynamic'
param skuCode string = 'Y1'
param functionRuntime string = 'node'
param functionExtensionVersion string = '~4'

// param workerSize string ='0'
// param workerSizeId string = '0'
// param numberOfWorkers string = '1'

//param appInsightsInstrumentationKey string
//var appInsightsName = '${appNamePrefix}-appinsights'

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

// // Blob Services for Storage Account
// resource blobServices 'Microsoft.Storage/storageAccounts/blobServices@2021-09-01' = {
//   parent: storageAccount
//   name: 'default'
//   properties: {
//     cors: {
//       corsRules: []
//     }
//     deleteRetentionPolicy: {
//       enabled: true
//       days: 7
//     }
//   }
// }

// App Service
resource appService 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: functionAppServiceName
  location: location
  kind: 'linux'
  tags: defaultTags
  sku: {
    name: skuCode
    tier: sku
    size: skuCode
    family: 'Y'
    capacity: 0
  }
  properties: {
    perSiteScaling: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: false
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
  }
}

// Function App
resource functionApp 'Microsoft.Web/sites@2021-03-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp,linux'
  tags: defaultTags
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: '${functionAppName}.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: '${functionAppName}.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
    ]
    serverFarmId: appService.id
    reserved: false
    isXenon: false
    hyperV: false
    siteConfig: {
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
      ]
      linuxFxVersion: linuxFxVersion
      ftpsState: ftpsState
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: false
    clientCertEnabled: false
    hostNamesDisabled: false
    dailyMemoryTimeQuota: 0
    httpsOnly: true
    redundancyMode: 'None'
  }
  // identity: {
  //   type:'SystemAssigned'
  // }
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

// // Function App Binding
// resource functionAppBinding 'Microsoft.Web/sites/hostNameBindings@2021-03-01' = {
//   parent: functionApp
//   name: '${functionApp.name}.azurewebsites.net'
//   properties: {
//     siteName: functionApp.name
//     hostNameType: 'Verified'
//   }
// }

// resource functionAppServiceAppSettings 'Microsoft.Web/sites/siteextensions@2021-03-01' = {
//   parent: functionApp
//   name: 'Microsoft.ApplicationInsights.AzureWebSites'
// }

// Reference Existing resource
// resource existingkeyvault 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
//   name: keyvaultName
// }

//var secretAzureWebJobsStorage = 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'

// create secret
// resource mySecret3 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
//   name: '${keyvaultName}/${secretName3}'
//   //parent: existingkeyvault
//   properties: {
//     contentType: 'text/plain'
//     //value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'
//     value: secretAzureWebJobsStorage
//   }
// }
// create secret
// resource mySecret4 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
//   name: '${keyvaultName}/${secretName4}'
//   //parent: existingkeyvault
//   properties: {
//     contentType: 'text/plain'
//     //value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'
//     value: secretAzureWebJobsStorage
//   }
// }

// output out_funcAppServiceprincipalId string = functionApp.identity.principalId
// output out_AzureWebJobsStorage string = secretAzureWebJobsStorage