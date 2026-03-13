#!/bin/bash

# Configuration
BACKUP_DIR="./backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
DB_CONTAINER="mariadb"
NEXTCLOUD_CONTAINER="nextcloud"
DB_NAME="nextcloud"
DB_USER="nextcloud"
DB_PASS="nextcloud"

# Création du dossier de sauvegarde s'il n'existe pas
mkdir -p "$BACKUP_DIR"

echo "--- Démarrage de la sauvegarde PCA/PRA ---"

# 1. Mise en mode maintenance de Nextcloud (Optionnel mais recommandé pour la cohérence des données)
# echo "Mise de Nextcloud en mode maintenance..."
# docker exec -u www-data "$NEXTCLOUD_CONTAINER" php occ maintenance:mode --on

# 2. Sauvegarde de la base de données
echo "Sauvegarde de la base de données MariaDB..."
docker exec "$DB_CONTAINER" mysqldump -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" > "$BACKUP_DIR/db_backup_$TIMESTAMP.sql"

# 3. Sauvegarde des fichiers de configuration (indispensable pour restaurer)
echo "Sauvegarde des fichiers de configuration Nextcloud..."
docker exec "$NEXTCLOUD_CONTAINER" tar -czf - config/ > "$BACKUP_DIR/config_backup_$TIMESTAMP.tar.gz"

# 4. Sauvegarde des données utilisateurs (Peut être lourd, à adapter selon le volume)
# echo "Sauvegarde des données utilisateurs Nextcloud..."
# docker exec "$NEXTCLOUD_CONTAINER" tar -czf - data/ > "$BACKUP_DIR/data_backup_$TIMESTAMP.tar.gz"

# 5. Sortie du mode maintenance
# echo "Désactivation du mode maintenance..."
# docker exec -u www-data "$NEXTCLOUD_CONTAINER" php occ maintenance:mode --off

# Compression finale
tar -czf "$BACKUP_DIR/full_backup_$TIMESTAMP.tar.gz" "$BACKUP_DIR/db_backup_$TIMESTAMP.sql" "$BACKUP_DIR/config_backup_$TIMESTAMP.tar.gz"
rm "$BACKUP_DIR/db_backup_$TIMESTAMP.sql" "$BACKUP_DIR/config_backup_$TIMESTAMP.tar.gz"

echo "--- Sauvegarde terminée ! Fichier : $BACKUP_DIR/full_backup_$TIMESTAMP.tar.gz ---"
