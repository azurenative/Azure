param bastionResourceName string
param location string

resource BastionHost 'Microsoft.Network/bastionHosts@2021-03-01' = {
  name: bastionResourceName
  location: location
  properties: {
    ipConfigurations: [
      {
        id: ''
        name: ''
        properties: {
          subnet: {
            id: ''
          }
         publicIPAddress: {
           id: ''
          }
        }
      }
    ]
  } 
}
