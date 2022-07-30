param location string = resourceGroup().location
//param webSiteName string
param appInsightsName string
param appInsightsWorkspaceName string
param appInsightsAlertName string
param defaultTags object
//param releaseAnnotationGuid string = newGuid()
//param releaseAnnotationDateStamp string = utcNow('yyyy-MM-ddTHH:mm:ss')

// Log Analytics workspace for Application Insights
resource applicationInsightsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: appInsightsWorkspaceName
  location: location
  properties:{
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    features: {
      searchVersion: 1
      legacy: 0
      enableLogAccessUsingOnlyResourcePermissions: true
    }
  }
}

// Application Insights
resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  tags: defaultTags
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: applicationInsightsWorkspace.id
  }
}

output out_appInsightsInstrumentationKey string = applicationInsights.properties.InstrumentationKey
output out_appInsightsConnectionString string = applicationInsights.properties.ConnectionString
