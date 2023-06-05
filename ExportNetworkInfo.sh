#!/bin/bash
# Export /etc/pihole/dhcp.leases and the relevant tables of $DB to CSV files for
# easy viewing.

EXPORT_DIR="exported"
mkdir -p "$EXPORT_DIR"

DB="/etc/pihole/pihole-FTL.db"

# For each table we want to export in $DB, write its header row followed by the
# contents of the table. We know the header rows from reading the schema with
# sqlite3 "$DB" ".schema $table"                which gives:
# CREATE TABLE IF NOT EXISTS "network_addresses" ( network_id INTEGER             NOT NULL, ip     TEXT UNIQUE NOT NULL, lastSeen  INTEGER NOT NULL DEFAULT (cast(strftime('%s', 'now') as int)), name TEXT, nameUpdated INTEGER, FOREIGN KEY(network_id) REFERENCES network(id));
# CREATE TABLE IF NOT EXISTS "network"           ( id         INTEGER PRIMARY KEY NOT NULL, hwaddr TEXT UNIQUE NOT NULL, interface TEXT    NOT NULL, firstSeen INTEGER NOT NULL, lastQuery INTEGER NOT NULL, numQueries INTEGER NOT NULL, macVendor TEXT, aliasclient_id INTEGER);
# CREATE TABLE                aliasclient        ( id         INTEGER PRIMARY KEY NOT NULL, name   TEXT        NOT NULL, comment   TEXT);
for table in network_addresses network aliasclient; do
    case $table in
        network_addresses) echo "network_id,ip,lastSeen,name,nameUpdated" ;;
        network)           echo "id,hwaddr,interface,firstSeen,lastQuery,numQueries,macVendor,aliasclient_id" ;;
        aliasclient)       echo "id,name,comment" ;;
    esac > "$EXPORT_DIR/$table.csv"

    sqlite3 "$DB" "SELECT * FROM $table" | tr "," " " | tr "|" "," >> "$EXPORT_DIR/$table.csv"
done

# Also export dhcp.leases
echo "expiry,mac,ip,hostname,dhcp_uid" > "$EXPORT_DIR/dhcp_leases.csv"
cat /etc/pihole/dhcp.leases | tr " " "," >> "$EXPORT_DIR/dhcp_leases.csv"
