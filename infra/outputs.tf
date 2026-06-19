# ── OUTPUTS ────────────────────────────────────────────────
output "namespace" {
  description = "Namespace Kubernetes déployé"
  value       = kubernetes_namespace.truck_medoc.metadata[0].name
}

output "api_service_name" {
  description = "Nom du service API"
  value       = kubernetes_service.api_service.metadata[0].name
}

output "frontend_service_name" {
  description = "Nom du service Frontend"
  value       = kubernetes_service.frontend_service.metadata[0].name
}

output "mysql_service_name" {
  description = "Nom du service MySQL"
  value       = kubernetes_service.mysql_service.metadata[0].name
}

output "api_replicas" {
  description = "Nombre de replicas API"
  value       = var.api_replicas
}

output "frontend_replicas" {
  description = "Nombre de replicas Frontend"
  value       = var.frontend_replicas
}
