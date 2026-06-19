# Ce fichier contient les valeurs sensibles — NE JAMAIS commiter sur Git
# Il est dans le .gitignore

namespace       = "truck-medoc"
environment     = "development"
docker_username = "francisvirginius"

api_replicas       = 2
api_image_tag      = "latest"
frontend_replicas  = 2
frontend_image_tag = "latest"

# Secrets MySQL — à remplacer par Vault plus tard
mysql_database      = "molecules"
mysql_user          = "apiuser"
mysql_password      = "apipassword"
mysql_root_password = "TruckMedoc2024!"
