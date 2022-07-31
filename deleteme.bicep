param subscriptionId string = 'f5e66d29-1a7f-4ee3-822e-74f644d3e665'
param name string = 'func-mercuryhealth-ceruleoscope'
param location string = 'East US 2'
param hostingPlanName string = 'SP-funcmercuryhealthceruleoscopegr-ae2d'
param serverFarmResourceGroup string = 'func-mercuryhealth-ceruleoscope_group'
//param alwaysOn bool = false
//param use32BitWorkerProcess bool
param ftpsState string = 'FtpsOnly'
param storageAccountName string = 'funcmercuryhealthceb54f'
param linuxFxVersion string = 'Node|16'
param sku string = 'Dynamic'
param skuCode string = 'Y1'
param workerSize string ='0'
param workerSizeId string = '0'
param numberOfWorkers string = '1'

resource name_resource 'Microsoft.Web/sites@2018-11-01' = {
  name: name
  kind: 'functionapp,linux'
  location: location
  tags: {
    'hidden-link: /app-insights-resource-id': '/subscriptions/f5e66d29-1a7f-4ee3-822e-74f644d3e665/resourceGroups/func-mercuryhealth-ceruleoscope_group/providers/Microsoft.Insights/components/appi-mercuryhealth-ceruleoscope'
  }
  properties: {
    name: name
    siteConfig: {
      appSettings: [
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'node'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: reference('microsoft.insights/components/appi-mercuryhealth-ceruleoscope', '2015-05-01').InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: reference('microsoft.insights/components/appi-mercuryhealth-ceruleoscope', '2015-05-01').ConnectionString
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${listKeys(storageAccountName_resource.id, '2019-06-01').keys[0].value};EndpointSuffix=core.windows.net'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${listKeys(storageAccountName_resource.id, '2019-06-01').keys[0].value};EndpointSuffix=core.windows.net'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: '${toLower(name)}9b2e'
        }
      ]
      cors: {
        allowedOrigins: [
          'https://ms.portal.azure.com'
        ]
      }
      use32BitWorkerProcess: use32BitWorkerProcess
      linuxFxVersion: linuxFxVersion
      ftpsState: ftpsState
    }
    serverFarmId: '/subscriptions/${subscriptionId}/resourcegroups/${serverFarmResourceGroup}/providers/Microsoft.Web/serverfarms/${hostingPlanName}'
    clientAffinityEnabled: false
    virtualNetworkSubnetId: null
    httpsOnly: true
  }
  dependsOn: [
    appi_mercuryhealth_ceruleoscope
    hostingPlanName_resource
  ]
}

resource hostingPlanName_resource 'Microsoft.Web/serverfarms@2018-11-01' = {
  name: hostingPlanName
  location: location
  kind: 'linux'
  tags: {}
  properties: {
    name: hostingPlanName
    workerSize: workerSize
    workerSizeId: workerSizeId
    numberOfWorkers: numberOfWorkers
    reserved: true
  }
  sku: {
    Tier: sku
    Name: skuCode
  }
  dependsOn: []
}

resource appi_mercuryhealth_ceruleoscope 'microsoft.insights/components@2020-02-02-preview' = {
  name: 'appi-mercuryhealth-ceruleoscope'
  location: 'eastus2'
  tags: {}
  properties: {
    ApplicationId: name
    Request_Source: 'IbizaWebAppExtensionCreate'
    Flow_Type: 'Redfield'
    Application_Type: 'web'
    WorkspaceResourceId: '/subscriptions/f5e66d29-1a7f-4ee3-822e-74f644d3e665/resourcegroups/defaultresourcegroup-eus/providers/microsoft.operationalinsights/workspaces/defaultworkspace-f5e66d29-1a7f-4ee3-822e-74f644d3e665-eus'
  }
  dependsOn: []
}

resource storageAccountName_resource 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  location: location
  tags: {}
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
  }
}
