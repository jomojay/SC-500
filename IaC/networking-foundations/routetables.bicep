param location string
resource rtApp 'Microsoft.Network/routeTables@2023-09-01' = {
  name: 'rt-future-inspection-app'
  location: location
  properties: {
    disableBgpRoutePropagation: true
  }
}

resource rtAks 'Microsoft.Network/routeTables@2023-09-01' = {
  name: 'rt-future-inspection-aks'
  location: location
  properties: {
    disableBgpRoutePropagation: true
  }
}
