param location string
resource appNsg 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'nsg-app'
  location: location
  properties: {
    securityRules: []
  }
}

resource appVnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: 'vnet-app'
  location: location
  properties: {
    addressSpace: { addressPrefixes: ['10.21.0.0/16'] }
    subnets: [
      {
        name: 'snet-app'
        properties: {
          addressPrefix: '10.21.1.0/24'
          networkSecurityGroup: {
            id: appNsg.id
          }
        }
      }
      {
        name: 'snet-integration'
        properties: {
          addressPrefix: '10.21.2.0/24'
        }
      }
      {
        name: 'snet-private-endpoints'
        properties: {
          addressPrefix: '10.21.3.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
    ]
  }
}
output vnetId string = appVnet.id
output vnetName string = appVnet.name
