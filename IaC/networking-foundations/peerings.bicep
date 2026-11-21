param hubVnetId string
param appVnetId string
param aksVnetId string
param hubVnetName string
param appVnetName string
param aksVnetName string
resource hubVnet 'Microsoft.Network/virtualNetworks@2023-09-01' existing = { name: hubVnetName }
resource appVnet 'Microsoft.Network/virtualNetworks@2023-09-01' existing = { name: appVnetName }
resource aksVnet 'Microsoft.Network/virtualNetworks@2023-09-01' existing = { name: aksVnetName }
resource hubToApp 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  parent: hubVnet
  name: 'hub-to-app'
  properties: {
    remoteVirtualNetwork: {
      id: appVnetId
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

resource appToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  parent: appVnet
  name: 'app-to-hub'
  properties: {
    remoteVirtualNetwork: {
      id: hubVnetId
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

resource hubToAks 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  parent: hubVnet
  name: 'hub-to-aks'
  properties: {
    remoteVirtualNetwork: {
      id: aksVnetId
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

resource aksToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  parent: aksVnet
  name: 'aks-to-hub'
  properties: {
    remoteVirtualNetwork: {
      id: hubVnetId
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}
