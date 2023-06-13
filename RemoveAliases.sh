#!/bin/bash
# Remove all aliases stored in the database.

DB="/etc/pihole/pihole-FTL.db"

# For every record in the network table, unlink it from any alias
sudo sqlite3 "$DB" "UPDATE network SET aliasclient_id=null"

# Delete every record in the aliasclient table
sudo sqlite3 "$DB" "DELETE FROM aliasclient"

# Re-load alias-clients
sudo pkill -SIGRTMIN+3 pihole-FTL
