#!/bin/bash
# Set aliases shown on the Pi-hole web interface to those in aliases.csv.

DB="/etc/pihole/pihole-FTL.db"

# Read from aliases.csv and update $DB
while IFS="," read -r mac alias; do
    echo "Setting alias of '$mac' to '$alias'"

    # Ensure the alias is already in the aliasclient table (add if not) and get id
    aliasclient_id=$(sqlite3 "$DB" "SELECT id FROM aliasclient WHERE name='$alias'")
    if [ "$aliasclient_id" == "" ]; then
        sudo sqlite3 "$DB" "INSERT INTO aliasclient (name) VALUES ('$alias')"
        aliasclient_id=$(sqlite3 "$DB" "SELECT id FROM aliasclient WHERE name='$alias'")
    fi

    # Link to the alias from the network table
    sudo sqlite3 "$DB" "UPDATE network SET aliasclient_id='$aliasclient_id' WHERE hwaddr='$mac'"
done < aliases.csv

# Re-load alias-clients
sudo pkill -SIGRTMIN+3 pihole-FTL
