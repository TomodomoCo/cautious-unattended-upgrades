# Cautious Unattended Upgrades
Cautious Unattended Upgrades (CUU) is a system for installing Debian `unattended-upgrades` on a test server,
then running a Ruby-based test suite on this test server to ensure that these upgrades have not broken any critical functionality
of your production environment.

If all is well, CUU will 'push' a list of the tested upgrades down to its CUU clients' `unattended-upgrades` package whitelist,
so they will run these upgrades on the next scheduled run.

# Requirements

## CUU Test Server

* `unattended-upgrades` configured to go wild and install all the new (security) updates you desire

## CUU Clients

* `unattended-upgrades` version 0.83 or higher (for Whitelist support) installed and configured
* a cron job to clear the package whitelist after the each execution of `unattended-upgrades`
