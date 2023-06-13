#!/bin/bash
# Update hostnames shown by Pi-hole using those saved in dhcp.leases and overrides.

DB="/etc/pihole/pihole-FTL.db"
now=$(date +%s)

# Read from /etc/pihole/dhcp.leases and update $DB
while IFS=" " read -r expiry mac ip hostname dhcp_uid; do
    if [ "$hostname" != "*" ]; then
        echo "Setting hostname of '$ip' to '$hostname' as found in dhcp.leases"

        # Note: We set the hostname of the IP address from dhcp.leases, but there may be other
        # IP addresses associated with this MAC address for which we do not set the hostname.
        sudo sqlite3 "$DB" "UPDATE network_addresses SET name='$hostname', nameUpdated='$now' WHERE ip='$ip'"
    fi
done < /etc/pihole/dhcp.leases

# Read from override_hostnames.csv and update $DB
while IFS="," read -r mac hostname; do
    echo "Overriding hostname of '$mac' to '$hostname'"

    # Set the hostname of all IPs with this MAC address. NOTE: there may be more than one.
    network_id=$(sqlite3 "$DB" "SELECT id FROM network WHERE hwaddr='$mac'")
    sudo sqlite3 "$DB" "UPDATE network_addresses SET name='$hostname', nameUpdated='$now' WHERE network_id='$network_id'"
done < override_hostnames.csv
