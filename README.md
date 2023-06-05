# Pi-hole Hostnames

Scripts to view and override hostnames in the Pi-hole web interface.

## Override Hostnames List

Hostnames that the user wants to override should be stored in `override_hostnames.csv` in simple CSV format. Each line should contain a MAC address with lowercase letters and colons followed by a comma followed by a hostname. There must be a trailing newline at the end of the file.

An example file has been provided as `example_override_hostnames.csv`.

## Override Hostnames Script

`OverrideHostnames.sh` overrides hostnames stored in `/etc/pihole/pihole-FTL.db` using hostnames given in the CSV file explained above.

If Pi-hole is setup as a DHCP server then it will collect hostnames though that which we refresh at the beginning of the script using a [signal](https://docs.pi-hole.net/ftldns/signals/). However, hostnames that are not shared by devices must be set manually in the CSV file which are then used to update the database.

The `name` field of the `network_addresses` table stores a hostname for each IP address (IPv4 and IPv6) so we set this. Note we set the hostname for all IP addresses associated with the MAC address in the override CSV file. If a single MAC address has multiple IP addresses then in the network tab of the web interface, the hostname will be repeated for each (but this cosmetic difference is all).

## Export Script

`ExportNetworkInfo.sh` exports `/etc/pihole/dhcp.leases` and the relevant tables of `/etc/pihole/pihole-FTL.db` to CSV files for easy viewing.

## Compare Changes Script

This exports the tables before and after updating the hostnames so they can be compared. It can also be helpful for catching mistakes as the old state of the tables is known so it can be reset to this. Note we don't do this to dhcp.leases since this doesn't change when updating hostnames.
