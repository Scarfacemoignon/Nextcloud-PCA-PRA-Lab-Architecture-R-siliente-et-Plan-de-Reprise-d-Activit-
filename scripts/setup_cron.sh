#!/bin/bash

# Chemin absolu vers le dossier du projet
PROJECT_DIR=$(pwd)
BACKUP_SCRIPT="$PROJECT_DIR/scripts/backup.sh"

# Créer une tâche cron pour s'exécuter toutes les heures
# (0 * * * *) = à la minute 0 de chaque heure
(crontab -l 2>/dev/null; echo "0 * * * * cd $PROJECT_DIR && $BACKUP_SCRIPT >> $PROJECT_DIR/backups/backup_log.txt 2>&1") | crontab -

echo "--- Automatisation activée ! ---"
echo "Les sauvegardes seront effectuées toutes les heures."
echo "Pour vérifier la liste des tâches : crontab -l"
