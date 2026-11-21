param location string
resource aksNsg 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'nsg-aks'
  location: location
  properties: {
    securityRules: []
  }
}

resource aksVnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: 'vnet-aks'
  location: location
  properties: {
    addressSpace: { addressPrefixes: ['10.22.0.0/16'] }
    subnets: [
      {
        name: 'snet-aks'
        properties: {
          addressPrefix: '10.22.2.0/23'
          networkSecurityGroup: {
            id: aksNsg.id
          }
        }
      }
    ]
  }
}
output vnetId string = aksVnet.id
output vnetName string = aksVnet.name
