#!/bin/bash
# Override hostnames of devices with certain MAC addresses.

DB="/etc/pihole/pihole-FTL.db"
now=$(date +%s)

# Re-resolve all hostnames
sudo pkill -SIGRTMIN+4 pihole-FTL

# Read from override_hostnames.csv and update $DB
while IFS="," read -r mac hostname; do
    echo "Overriding hostname of '$mac' to '$hostname'"

    # Set the hostname of all IPs with this MAC address. NOTE: there may be more than one.
    network_id=$(sqlite3 "$DB" "SELECT id FROM network WHERE hwaddr='$mac'")
    sudo sqlite3 "$DB" "UPDATE network_addresses SET name='$hostname', nameUpdated='$now' WHERE network_id='$network_id'"
done < override_hostnames.csv
