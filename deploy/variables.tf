variable "cluster_name" {
    type = string
}

variable "environment" {
    type = string
}

variable "name" {
    type = string
    default = "node-app"
}

variable "ecs_family_name" {
    type    = string
    default = "node-app"
}

variable "ecs_task_definition_name" {
    type    = string
    default = "node-app-task"
}

variable "ecs_service_name" {
    type    = string
    default = "node-app-service"
}

variable "desired_count" {
    type    = number
    default = 1
}

variable "alb_name" {
    type    = string
    default = "alb-node-app"
}