#!/bin/bash
# Export the tables, rename them, update hostnames, and then export the tables
# again so they can be compared. This can be helpful for catching mistakes as
# the old state of the tables is known so it can be reset to this. Note we don't
# do this to dhcp.leases since this doesn't change when updating hostnames.

EXPORT_DIR="exported"

./ExportNetworkInfo.sh
for table in network_addresses network aliasclient; do
    mv "$EXPORT_DIR/$table.csv" "$EXPORT_DIR/${table}_old.csv"
done
./OverrideHostnames.sh
./ExportNetworkInfo.sh
