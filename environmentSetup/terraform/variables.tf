variable "primary_region" {
    type = string
    default     = "northeurope"
    description = "Primary region"
}

variable "primary_region_resource_group" {
    type = string
    default     = "rgDemoPrimaryRegion"
    description = "Resource group for the primary azure region"
}

variable "secondary_region" {
    type = string
    default     = "westeurope"
    description = "Secondary region"
}

variable "secondary_region_resource_group" {
    type = string
    default     = "rgDemoSecondaryRegion"
    description = "Resource group for the secondary azure region"
}

variable "app_service_plan_name" {
    type = string
    default     = "MyPlan"
    description = "App Service Plan name"
}

variable "primary_region_web_app_name" {
    type = string
    default     = "learningDayRegion1WebApp"
    description = "App Service Plan name"
}

variable "secondary_region_web_app_name" {
    type = string
    default     = "learningDayRegion2WebApp"
    description = "App Service Plan name"
}
