
LAB PCA PRA NEXTCLOUD

Ce dossier contient l'environnement technique du TP.

Contenu :
- docker-compose.yml : déploiement de la plateforme
- nginx/ : configuration reverse proxy
- monitoring/ : configuration Prometheus
- dataset/ : fichiers d'entreprise simulés
- scripts/ : exemples scripts sauvegarde et restauration

Démarrage :
docker compose up -d

Services :
Nextcloud : http://localhost:8080
Prometheus : http://localhost:9090
Grafana : http://localhost:3000
