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

# Aliases

Pi-hole has a relatively new feature called Alias Clients which are intended to group clients under the same name (alias) for statistics. [See this for more information](https://discourse.pi-hole.net/t/info-request-pihole-ftl-db/43120) which suggests it may be incorporated into the web interface in the future. Until then, we add a CSV file and script to do this.

Note that it does group them in the top clients lists (total and blocked), but completely excludes all clients with aliases from the client activity graph.

## Aliases List

Alias that the user wants to set should be stored in `aliases.csv` in simple CSV format similarly to the override hostnames list. Each line should contain a MAC address with lowercase letters and colons followed by a comma followed by an alias name. There must be a trailing newline at the end of the file.

All MAC addresses associated with the same alias name in this CSV file will be grouped under this alias.

An example file has been provided as `example_aliases.csv`.

## Set Aliases Script

`SetAliases.sh` sets alias stored in `/etc/pihole/pihole-FTL.db` according to those in `aliases.csv`.

It does this by creating any aliases that do not already exist in the `aliasclient` table of `/etc/pihole/pihole-FTL.db` with sequential IDs and no comments. Then it links these IDs to the MAC addresses in the `network` table.

Finally a [signal](https://docs.pi-hole.net/ftldns/signals/) is sent to the `pihole-FTL` service to re-load aliases.

## Remove Aliases Script

`RemoveAliases.sh` removes all aliases in `/etc/pihole/pihole-FTL.db` which can be helpful for undoing what the set aliases script did. As long as all aliases were added using the set aliases script, no changes will have been lost as it can always be run again.

# Compare Changes Script

This exports the tables before and after running a given script so the state of the tables can be compared before and after. This can be helpful for catching mistakes as the old state of the tables is known so it can be reset to this. Note we don't do this to dhcp.leases since this doesn't change when updating hostnames.
