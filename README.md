# Pi-hole Hostnames

Scripts to view, update, and override hostnames in the Pi-hole web interface.

## Override Hostnames List

Hostnames that the user wants to override should be stored in `override_hostnames.csv` in simple CSV format. Each line should contain a MAC address with lowercase letters and colons followed by a comma followed by a hostname. There must be a trailing newline at the end of the file.

An example file has been provided as `example_override_hostnames.csv`.

## Update Hostnames Script

`UpdateHostnames.sh` updates hostnames stored in `/etc/pihole/pihole-FTL.db` using hostnames recorded in `/etc/pihole/dhcp.leases` and overrides in the CSV file explained above. If Pi-hole is setup as a DHCP server then it will be recording information in `dhcp.leases` including hostnames that devices share. So this is a good way of quickly setting most hostnames. Hostnames that are not shared by devices must be set as an override.

A [signal](https://docs.pi-hole.net/ftldns/signals/) can be sent to the `pihole-FTL` service to re-resolve all hostnames, but this does not seem to work in my testing, whereas directly copying from `dhcp.leases` does.

The `name` field of the `network_addresses` table in the database `/etc/pihole/pihole-FTL.db` stores a hostname for each IP address (IPv4 and IPv6) so we set this. Note that for hostnames found in `dhcp.leases`, we only set it for the IP address stored in `dhcp.leases`, whereas for hostnames stored in the override CSV file, we set it for all IP addresses associated with that MAC address. If a single MAC address has multiple IP addresses then in the network tab of the web interface, the hostname will be repeated for each (but this is the only difference and it's only cosmetic).

## Export Script

`ExportNetworkInfo.sh` exports `/etc/pihole/dhcp.leases` and the relevant tables of `/etc/pihole/pihole-FTL.db` to CSV files for easy viewing.

## Compare Changes Script

This exports the tables before and after updating the hostnames so they can be compared. It can also be helpful for catching mistakes as the old state of the tables is known so it can be reset to this. Note we don't do this to dhcp.leases since this doesn't change when updating hostnames.
