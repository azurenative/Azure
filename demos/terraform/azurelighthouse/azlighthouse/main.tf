terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.4.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = var.backend_resource_group_name
    storage_account_name = var.backend_storage_account_name
    container_name       = var.backend_container_name
    key                  = var.backend_key
  }
}

resource "azuread_group" "infpasygo-azn-azadgroups" {
  for_each                = var.azureadgroups
  display_name            = each.value["display_name"]
  description             = each.value["description"]
  security_enabled        = true
  prevent_duplicate_names = true
}

data "azuread_service_principal" "appreg" {
  display_name = "spn-aznative-t"
  depends_on = [
    azuread_group.infpasygo-azn-azadgroups
  ]
}

data "azuread_user" "azadusers_objectids" {
  for_each            = var.azadusers_developmentteam
  user_principal_name = each.value["user_principal_name"]
    depends_on = [
    azuread_group.infpasygo-azn-azadgroups
  ]
}




# data "azurerm_resource_group" "maz902-rg-t0003" {
#   name = "maz902-rg-t0003"
# }
# data "azurerm_resource_group" "maz902-rg-t0004" {
#   name = "maz902-rg-t0004"
# }

## using output from resource.

data "azuread_group" "deployment_principal_id" {
  display_name = "infpasygo-azn-deployment"
    depends_on = [
    azuread_group.infpasygo-azn-azadgroups
  ]
}

data "azuread_group" "development_principal_id" {
  display_name = "infpasygo-azn-development"
    depends_on = [
    azuread_group.infpasygo-azn-azadgroups
  ]
}

resource "azuread_group_member" "add-serviceprincipal" {
  group_object_id  = data.azuread_group.deployment_principal_id.object_id
  member_object_id = data.azuread_service_principal.appreg.object_id
  depends_on       = [azuread_group.infpasygo-azn-azadgroups]
}

resource "azuread_group_member" "add-userprincipal" {
  for_each         = data.azuread_user.azadusers_objectids
  group_object_id  = data.azuread_group.development_principal_id.object_id
  member_object_id = each.value["object_id"]
  depends_on       = [azuread_group.infpasygo-azn-azadgroups]
}

## definition subscription azure lighthouse assignments
resource "azurerm_lighthouse_definition" "developmentgroup" {
  name               = "delegated access Azurenative MSP"
  description        = "delegated access resource"
  managing_tenant_id = var.azadtenant_id
  scope              = var.tenant_subscription_scope
  dynamic "authorization" {
    for_each = toset(var.authorizationsDevelopment)
    content {
      principal_id       = data.azuread_group.development_principal_id.object_id
      role_definition_id = authorization.value.roleDefinitionId
    }
  }
  depends_on = [azuread_group.infpasygo-azn-azadgroups]
}

resource "azurerm_lighthouse_assignment" "developmentgroup" {
  scope                    = azurerm_lighthouse_definition.developmentgroup.scope
  lighthouse_definition_id = azurerm_lighthouse_definition.developmentgroup.id
  depends_on = [
    azurerm_lighthouse_definition.developmentgroup
  ]
}

resource "azurerm_lighthouse_definition" "deploymentgroup" {
  name               = "Azurenative MSP"
  description        = "delegated access resource"
  managing_tenant_id = var.azadtenant_id
  scope              = var.tenant_subscription_scope
  dynamic "authorization" {
    for_each = toset(var.authorizationsDeployment)

    content {
      principal_id       = data.azuread_group.deployment_principal_id.object_id
      role_definition_id = authorization.value.roleDefinitionId
    }
  }
  depends_on = [azurerm_lighthouse_definition.developmentgroup]
}

resource "azurerm_lighthouse_assignment" "deploymentgroup" {
  scope                    = azurerm_lighthouse_definition.deploymentgroup.scope
  lighthouse_definition_id = azurerm_lighthouse_definition.deploymentgroup.id
  depends_on = [
    azurerm_lighthouse_definition.deploymentgroup, azurerm_lighthouse_definition.developmentgroup, azurerm_lighthouse_assignment.developmentgroup
  ]
}
# azure lighthouse definition & assignments resource group scope #
# data "azuread_group" "operations_principal_id" {
#   display_name = "infpasygo-azn-operations"
#     depends_on = [
#     azuread_group.infpasygo-azn-azadgroups
#   ]
# }

# data "azuread_group" "AVDoperations_principal_id" {
#   display_name = "infpasygo-azn-AVDoperations"
#     depends_on = [
#     azuread_group.infpasygo-azn-azadgroups
#   ]
# }
# resource "azurerm_lighthouse_definition" "operationsgroup" {
#   name               = "Azurenative MSP"
#   description        = "delegated access resource"
#   managing_tenant_id = var.azadtenant_id
#   scope              = var.tenant_subscription_scope

#   dynamic "authorization" {
#     for_each = toset(var.rgauthorizationsOps)

#     content {
#       principal_id       = data.azuread_group.operations_principal_id.object_id
#       role_definition_id = authorization.value.roleDefinitionId
#     }
#   }
#   depends_on = [azurerm_lighthouse_definition.developmentgroup, azurerm_lighthouse_assignment.developmentgroup, azurerm_lighthouse_definition.developmentgroup, azurerm_lighthouse_assignment.developmentgroup]
# }

# #assignment is the scope assigning the delegated permissions to
# resource "azurerm_lighthouse_assignment" "operationsgroup" {
#   scope                    = data.azurerm_resource_group.maz902-rg-t0003.id
#   lighthouse_definition_id = azurerm_lighthouse_definition.operationsgroup.id
#   depends_on = [
#     azurerm_lighthouse_definition.deploymentgroup, azurerm_lighthouse_definition.developmentgroup, azurerm_lighthouse_assignment.developmentgroup, azurerm_lighthouse_definition.operationsgroup
#   ]
# }
# ####
# resource "azurerm_lighthouse_definition" "AVDoperationsgroup" {
#   name               = "Azurenative MSP"
#   description        = "delegated access resource"
#   managing_tenant_id = var.azadtenant_id
#   scope              = var.tenant_subscription_scope

#   dynamic "authorization" {
#     for_each = toset(var.rgauthorizationsAVD)

#     content {
#       principal_id       = data.azuread_group.AVDoperations_principal_id.object_id
#       role_definition_id = authorization.value.roleDefinitionId
#     }
#   }
#   depends_on = [azurerm_lighthouse_definition.developmentgroup, azurerm_lighthouse_assignment.developmentgroup, azurerm_lighthouse_definition.developmentgroup, azurerm_lighthouse_assignment.developmentgroup]
# }
# #assignment is the scope assigning the delegated permissions to
# resource "azurerm_lighthouse_assignment" "AVDoperationsgroup" {
#   scope                    = data.azurerm_resource_group.maz902-rg-t0004.id
#   lighthouse_definition_id = azurerm_lighthouse_definition.AVDoperationsgroup.id
#   depends_on = [
#     azurerm_lighthouse_definition.deploymentgroup, azurerm_lighthouse_definition.developmentgroup, azurerm_lighthouse_assignment.developmentgroup, azurerm_lighthouse_definition.operationsgroup, azurerm_lighthouse_assignment.operationsgroup, azurerm_lighthouse_definition.AVDoperationsgroup
#   ]
# }
