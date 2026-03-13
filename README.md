# Nextcloud PCA/PRA Lab : Architecture Résiliente et Plan de Reprise d'Activité

Ce projet propose une infrastructure complète et résiliente pour le déploiement de **Nextcloud**, mettant l'accent sur les stratégies de **Plan de Continuité d'Activité (PCA)** et de **Plan de Reprise d'Activité (PRA)** dans un environnement conteneurisé.

## 🚀 Vue d'ensemble de l'Architecture

L'infrastructure est orchestrée avec **Docker Compose** et s'appuie sur une architecture multi-services :

- **Nginx (Reverse Proxy)** : Point d'entrée sécurisé pour les utilisateurs (Port 8080).
- **Nextcloud (Apache)** : Serveur d'application pour la collaboration documentaire.
- **MariaDB** : Base de données relationnelle pour la gestion des métadonnées.
- **Redis** : Gestion du cache et des verrous de fichiers pour optimiser les performances.
- **Monitoring Stack** : 
  - **Prometheus** : Serveur de collecte de métriques.
  - **Grafana** : Tableaux de bord de visualisation temps réel (Port 3000).
  - **cAdvisor** : Collecte des métriques de ressources des conteneurs.
  - **mysqld-exporter** : Surveillance spécifique de la base de données.

---

## 🛡️ Stratégie PCA (Plan de Continuité d'Activité)

Le PCA assure que le service reste disponible et que les incidents sont détectés avant qu'ils ne deviennent critiques.

### 1. Surveillance et Observabilité
Le système de monitoring permet une visibilité totale sur l'état de santé de l'infrastructure :
- **Tableaux de bord Grafana** : Visualisation du CPU, de la RAM et de l'état du réseau pour chaque conteneur.
- **Alerting Ready** : Prometheus est configuré pour scraper les métriques toutes les 5 secondes, permettant une détection quasi instantanée des pannes.

### 2. Auto-réparation
Tous les conteneurs sont configurés avec la directive `restart: always`, permettant à Docker de relancer automatiquement tout service qui viendrait à échouer.

---

## 🔧 Stratégie PRA (Plan de Reprise d'Activité)

Le PRA définit les outils et procédures pour restaurer le service après un sinistre majeur (ex: perte de volume, corruption de base de données).

### 1. Sauvegardes Automatisées
Un script de sauvegarde (`scripts/backup.sh`) est implémenté pour protéger :
- Le dump complet de la base de données **MariaDB**.
- Les fichiers de configuration critiques de **Nextcloud**.
- L'automatisation est gérée par une tâche **Cron** (configurée via `scripts/setup_cron.sh`).

### 2. Procédure de Restauration
Un script de restauration (`scripts/restore.sh`) permet de reconstruire l'environnement à partir d'une archive de sauvegarde. La reprise après sinistre a été testée et validée en moins de 5 minutes (**RTO bas**).

---

## 🛠️ Utilisation et Installation

### Pré-requis
- Docker et Docker Compose installés sur la machine hôte.

### Déploiement
```bash
docker compose up -d
```

### Configuration des sauvegardes
```bash
chmod +x scripts/*.sh
./scripts/setup_cron.sh
```

### Accès aux services
- **Nextcloud** : [http://localhost:8080](http://localhost:8080)
- **Prometheus** : [http://localhost:9090](http://localhost:9090)
- **Grafana** : [http://localhost:3000](http://localhost:3000) (admin / admin)

---

## 📊 Tests Réalisés
- [x] **Redirection Proxy** : Validation de l'accès via Nginx sur le port 8080.
- [x] **Monitoring Flow** : Vérification de la remontée des métriques cAdvisor et MariaDB.
- [x] **Simulation de Crash** : Suppression volontaire du volume `db_data`.
- [x] **Restauration** : Succès de la reprise via `restore.sh` avec intégrité des données préservée.

---
*Projet réalisé dans le cadre du module PCA/PRA - Master 2026.*
