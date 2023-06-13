#!/bin/bash
# Export the tables, rename them, run the given script, and then export
# the tables again so they can be compared. This can be helpful for catching
# mistakes as the old state of the tables is known so it can be reset to this.
# Note we don't do this to dhcp.leases since this doesn't change.

if [ $# -lt 1 ]; then
    echo "Must enter the script to run to compare before and after such as './UpdateHostnames.sh'"
fi

EXPORT_DIR="exported"

./ExportNetworkInfo.sh
for table in network_addresses network aliasclient client_by_id ; do
    mv "$EXPORT_DIR/$table.csv" "$EXPORT_DIR/${table}_old.csv"
done
$1
./ExportNetworkInfo.sh
