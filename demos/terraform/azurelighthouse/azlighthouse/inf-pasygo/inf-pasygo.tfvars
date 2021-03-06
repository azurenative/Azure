tenant_subscription_scope = "/subscriptions/d395dff9-7546-438a-b9b6-6fb17f94ca23"
#### azure ad group object ####
azureadgroups = {
  "group1" = {
    display_name = "infpasygo-azn-deployment"
    description  = "This AZAD Group contains App Registration to deploy resources within the subscription"
  },
  "group2" = {
    display_name = "infpasygo-azn-development"
    description  = "This AZAD Group contains user principals of the developers team"
  },
  "group3" = {
    display_name = "infpasygo-azn-operations"
    description  = "This AZAD Group contains user principals of the Operations team"
  },
  "group4" = {
    display_name = "infpasygo-azn-AVDoperations"
    description  = "This AZAD Group contains users to operate and manage Azure Virtual Desktop resources"
  },
}

#### azure ad user objects ####
azadusers_developmentteam = {
  "user1" = {
    user_principal_name = "cspjoe@azurenative.nl"
  },
  "user2" = {
    user_principal_name = "domadmin@azurenative.nl"
  }
}
# authorization objects azure lighthouse
authorizationsDeployment = [
  {
    principalId      = "infpasygo-azn-deployment"
    roleDefinitionId = "b24988ac-6180-42a0-ab88-20f7382dd24c" #Contributor - scope: subscription     
  },
  {
    principalId      = "infpasygo-azn-deployment"
    roleDefinitionId = "91c1777a-f3dc-4fae-b103-61d183457e46" # Managed Services Registration assignment Delete Role
  },
]

authorizationsDevelopment = [
  {
    principalId      = "infpasygo-azn-deployment"
    roleDefinitionId = "acdd72a7-3385-48ef-bd42-f606fba81ae7" #Reader - scope: subscription     
  },
  {
    principalId      = "infpasygo-azn-deployment"
    roleDefinitionId = "91c1777a-f3dc-4fae-b103-61d183457e46" # Managed Services Registration assignment Delete Role
  },
]
rgauthorizationsOps = [
  {
    principalId      = "infpasygo-azn-operations"
    roleDefinitionId = "c12c1c16-33a1-487b-954d-41c89c60f349" # Storage Account Contributor         
  },
  {
    principalId      = "infpasygo-azn-operations"
    roleDefinitionId = "73c42c96-874c-492b-b04d-ab87d138a893" # Log Analytics Reader       
  },
  {
    principalId      = "infpasygo-azn-operations"
    roleDefinitionId = "43d0d8ad-25c7-4714-9337-8ba259a9fe05" # Monitor Reader   
  },
  {
    principalId      = "infpasygo-azn-operations"
    roleDefinitionId = "acdd72a7-3385-48ef-bd42-f606fba81ae7" # Reader Resource Group
  },
]

rgauthorizationsAVD = [
  {
    principalId      = "infpasygo-azn-AVDoperations"
    roleDefinitionId = "49a72310-ab8d-41df-bbb0-79b649203868" #Desktop Virtualization Reader         
  },
  {
    principalId      = "infpasygo-azn-AVDoperations"
    roleDefinitionId = "ea4bfff8-7fb4-485a-aadd-d4129a0ffaa6" # Desktop Virtualization User Session Operator
  },
]
