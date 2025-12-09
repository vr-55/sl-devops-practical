variable "project_id" {
  type        = string
  description = "GCP project"
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "region" {
  type        = string
  description = "region"
  default     = "us-central1"
}

variable "zone" {
  type        = string
  description = "zone"
  default     = "us-central1-a"
}

variable "cluster_name" {
  type        = string
  description = "Cluster name"
  default     = "sl-practical-k8s"
}

variable "controller_count" {
  type        = number
  description = "controller nodes count"
  default     = 3
}

variable "worker_count" {
  type        = number
  description = "worker nodes count"
  default     = 3
}

variable "controller_instance_type" {
  type        = string
  description = "controller node instance type"
  default     = "e2-medium"
}

variable "worker_instance_type" {
  type        = string
  description = "worker node instance type"
  default     = "e2-medium"
}

variable "image" {
  type        = string
  description = "Boot image"
  default     = "projects/debian-cloud/global/images/family/debian-12"
}

variable "disk_size_gb" {
  type        = number
  description = "disk size in GB"
  default     = 50
}

variable "network" {
  type        = string
  description = "VPC network"
  default     = "default"
}

variable "subnet" {
  type        = string
  description = "subnet"
  default     = "default"
}

variable "username" {
  description = "ssh username"
  type        = string
  default     = "vr_social655"
}

variable "public_key_path" {
  description = "Path to public SSH key"
  type        = string
  default     = "/Users/chimalamarri.reddy/Venkat/sl/sl-ssh.pub"
}
