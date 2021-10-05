variable "backend_resource_group_name"{
  type = string
}

variable "backend_storage_account_name"{
  type = string
}

variable "backend_container_name"{
  type = string
}

variable "backend_key" {
  type = string
}
variable "subscription_id" {
  type        = string
  description = "Azure subscription id"
}

variable "tenant_id" {
  type        = string
  description = "Azure tenant id"
}

variable "client_id" {
  type        = string
  description = "Azure service principal name"
}

variable "client_secret" {
  type        = string
  description = "Azure service principal password"
}

variable "azadtenant_id" {
  type        = string
  description = "AzureAD tenant id"
}

variable "azadclient_id" {
  type        = string
  description = "AzureAD service principal name"
}

variable "azadclient_secret" {
  type        = string
  description = "AzureAD service principal password"
}

#### azure ad group object ####
variable "azureadgroups" {
  type = map(object({
    display_name     = string
    description = string
  }))
}

#### azure ad user objects ####
variable "azadusers_developmentteam" {
  type = map(object({
    user_principal_name = string    
  }))
}

variable "tenant_subscription_scope"{
  description = "tenant subscription resource id "
  type = string
}


variable "authorizationsDeployment" {
  description = "List of Authorization objects."
  type = list(object({
    principalId   = string    
    roleDefinitionId      = string
  }))
}

variable "authorizationsDevelopment" {
  description = "List of Authorization objects."
  type = list(object({
    principalId   = string    
    roleDefinitionId      = string
  }))
}

variable "rgauthorizationsOps" {
  description = "List of Authorization objects."
  type = list(object({
    principalId   = string    
    roleDefinitionId      = string
  }))
}

variable "rgauthorizationsAVD" {
  description = "List of Authorization objects."
  type = list(object({
    principalId   = string    
    roleDefinitionId      = string
  }))
}

  