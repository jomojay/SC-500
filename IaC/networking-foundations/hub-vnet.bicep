param location string
resource sharedNsg 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'nsg-shared'
  location: location
  properties: {
    securityRules: []
  }
}

resource hubVnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: 'vnet-hub'
  location: location
  properties: {
    addressSpace: { addressPrefixes: ['10.20.0.0/16'] }
    subnets: [
      {
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefix: '10.20.0.0/26'
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: '10.20.1.0/26'
        }
      }
      {
        name: 'snet-shared'
        properties: {
          addressPrefix: '10.20.2.0/24'
          networkSecurityGroup: {
            id: sharedNsg.id
          }
        }
      }
    ]
  }
}
output vnetId string = hubVnet.id
output vnetName string = hubVnet.name
