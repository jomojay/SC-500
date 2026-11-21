targetScope = 'subscription'

param resourceGroupName string
param location string

module hub './hub-vnet.bicep' = {
  name: 'hub-vnet'
  scope: resourceGroup(resourceGroupName)
  params: { location: location }
}

module app './app-vnet.bicep' = {
  name: 'app-vnet'
  scope: resourceGroup(resourceGroupName)
  params: { location: location }
}

module aks './aks-vnet.bicep' = {
  name: 'aks-vnet'
  scope: resourceGroup(resourceGroupName)
  params: { location: location }
}

module rt './routetables.bicep' = {
  name: 'route-tables'
  scope: resourceGroup(resourceGroupName)
  params: { location: location }
}

module peerings './peerings.bicep' = {
  name: 'peerings'
  scope: resourceGroup(resourceGroupName)
  params: {
    hubVnetId: hub.outputs.vnetId
    appVnetId: app.outputs.vnetId
    aksVnetId: aks.outputs.vnetId
    hubVnetName: hub.outputs.vnetName
    appVnetName: app.outputs.vnetName
    aksVnetName: aks.outputs.vnetName
  }
}
