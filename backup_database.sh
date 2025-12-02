#!/bin/bash
# Backup script for Golf Scramble database

BACKUP_DIR="./backups"
DATE=$(date +%Y%m%d_%H%M%S)
DB_FILE="golf_scramble.db"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Check if database exists
if [ ! -f "$DB_FILE" ]; then
    echo "❌ Error: Database file not found: $DB_FILE"
    exit 1
fi

# Create backup
BACKUP_FILE="$BACKUP_DIR/golf_scramble_$DATE.db"
cp "$DB_FILE" "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "✓ Database backed up to: $BACKUP_FILE"
    
    # Keep only last 10 backups
    ls -t "$BACKUP_DIR"/golf_scramble_*.db | tail -n +11 | xargs -r rm -f
    
    BACKUP_COUNT=$(ls -1 "$BACKUP_DIR"/golf_scramble_*.db 2>/dev/null | wc -l)
    echo "  Total backups: $BACKUP_COUNT"
else
    echo "❌ Error: Backup failed"
    exit 1
fi
