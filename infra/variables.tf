# ── GÉNÉRAL ───────────────────────────────────────────────
variable "namespace" {
  description = "Namespace Kubernetes pour TrackMedoc"
  type        = string
  default     = "truck-medoc"
}

variable "environment" {
  description = "Environnement de déploiement"
  type        = string
  default     = "development"
}

variable "docker_username" {
  description = "Nom d'utilisateur DockerHub"
  type        = string
  default     = "francisvirginius"
}

# ── API ────────────────────────────────────────────────────
variable "api_replicas" {
  description = "Nombre de replicas pour l'API"
  type        = number
  default     = 2
}

variable "api_image_tag" {
  description = "Tag de l'image Docker de l'API"
  type        = string
  default     = "latest"
}

# ── FRONTEND ───────────────────────────────────────────────
variable "frontend_replicas" {
  description = "Nombre de replicas pour le frontend"
  type        = number
  default     = 2
}

variable "frontend_image_tag" {
  description = "Tag de l'image Docker du frontend"
  type        = string
  default     = "latest"
}

# ── MYSQL ──────────────────────────────────────────────────
variable "mysql_database" {
  description = "Nom de la base de données MySQL"
  type        = string
  sensitive   = true
}

variable "mysql_user" {
  description = "Utilisateur MySQL"
  type        = string
  sensitive   = true
}

variable "mysql_password" {
  description = "Mot de passe MySQL"
  type        = string
  sensitive   = true
}

variable "mysql_root_password" {
  description = "Mot de passe root MySQL"
  type        = string
  sensitive   = true
}
