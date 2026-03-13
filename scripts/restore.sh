#!/bin/bash

# Configuration
BACKUP_FILE=$1
DB_CONTAINER="mariadb"
NEXTCLOUD_CONTAINER="nextcloud"
DB_NAME="nextcloud"
DB_USER="nextcloud"
DB_PASS="nextcloud"

if [ -z "$BACKUP_FILE" ]; then
    echo "Usage: $0 <path_to_backup_file.tar.gz>"
    exit 1
fi

echo "--- Démarrage de la restauration PCA/PRA ---"

# Extraction de la sauvegarde
mkdir -p ./restore_tmp
tar -xzf "$BACKUP_FILE" -C ./restore_tmp

# Récupération des fichiers SQL et TAR
SQL_FILE=$(find ./restore_tmp -name "*.sql")
CONFIG_TAR=$(find ./restore_tmp -name "config_backup_*.tar.gz")

# 1. Restauration de la base de données
echo "Restauration de la base de données MariaDB..."
docker exec -i "$DB_CONTAINER" mariadb -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" < "$SQL_FILE"

# 2. Restauration de la configuration
echo "Restauration des fichiers de configuration..."
docker cp "$CONFIG_TAR" "$NEXTCLOUD_CONTAINER":/tmp/config_restore.tar.gz
docker exec "$NEXTCLOUD_CONTAINER" tar -xzf /tmp/config_restore.tar.gz -C /var/www/html/
docker exec "$NEXTCLOUD_CONTAINER" rm /tmp/config_restore.tar.gz

# Ménage
rm -rf ./restore_tmp

echo "--- Restauration terminée ! Veuillez redémarrer les conteneurs. ---"
