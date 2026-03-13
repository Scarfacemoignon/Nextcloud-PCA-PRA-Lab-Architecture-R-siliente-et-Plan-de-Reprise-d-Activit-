# Récapitulatif du TP PCA/PRA - Plateforme Nextcloud

Ce document résume les actions entreprises pour la mise en œuvre du Plan de Continuité d'Activité (PCA) et du Plan de Reprise d'Activité (PRA) pour la plateforme collaborative Nextcloud.

## 1. Analyse de l'Architecture
L'infrastructure est déployée via **Docker Compose** et comprend :
- **Reverse Proxy (Nginx)** : Point d'entrée unique (Port 8080).
- **Application (Nextcloud)** : Moteur collaboratif.
- **Base de données (MariaDB)** : Stockage des métadonnées.
- **Cache (Redis)** : Optimisation des performances.
- **Monitoring (Prometheus/Grafana)** : Surveillance de l'état de santé.

## 2. Plan de Continuité d'Activité (PCA) - Monitoring
Le PCA repose sur la détection proactive des incidents :
- **cAdvisor** : Récupère les métriques d'utilisation des ressources (CPU, RAM) de chaque conteneur.
- **mysqld-exporter** : Surveille l'état de la base de données MariaDB.
- **Prometheus** : Centralise toutes les métriques.
- **Grafana** : Visualise les données sur des tableaux de bord (Port 3000).

## 3. Stratégie de Sauvegarde (Sauvegarde Automatisée)
Une stratégie de sauvegarde a été implémentée via le script `scripts/backup.sh` :
- **Données sauvegardées** : Dump SQL de la base MariaDB + Fichiers de configuration Nextcloud.
- **Format** : Archive compressée `.tar.gz` horodatée.
- **Automatisation** : Mise en place d'une tâche **Cron** pour une sauvegarde périodique (Script `scripts/setup_cron.sh`).

## 4. Plan de Reprise d'Activité (PRA) - Test de Restauration
Un test de reprise après sinistre a été réalisé avec succès :
1. **Simulation de l'incident** : Suppression du conteneur et du volume de la base de données (`tp_pca_pra_nextcloud_lab_db_data`).
2. **Constat** : Indisponibilité immédiate du service Nextcloud (Erreur 500).
3. **Action de reprise** : Exécution du script `scripts/restore.sh` avec la dernière sauvegarde.
4. **Résultat** : Service restauré et opérationnel en moins de 5 minutes.

## 5. Commandes Utiles
- **Lancer une sauvegarde manuelle** : `./scripts/backup.sh`
- **Restaurer une sauvegarde** : `./scripts/restore.sh ./backups/full_backup_XXX.tar.gz`
- **Vérifier le monitoring** : Accéder à `http://localhost:9090` (Prometheus) ou `http://localhost:3000` (Grafana).
- **Vérifier les sauvegardes automatiques** : `crontab -l`

---
*Réalisé le 13 Mars 2026 dans le cadre du cours PCA-PRA.*
