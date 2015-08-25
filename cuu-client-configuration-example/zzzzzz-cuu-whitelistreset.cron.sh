#!/bin/bash
#
# Cautious Unattended Upgrades -- Client Whitelist Rest
#
#
# This must be run by cron.daily as the **LAST** script it executes -- so perhaps
# called /etc/cron.daily/zzzzzz-cuu-whitelistreset
#
#

sed -i -e 's/Package-Blacklist {\([^}]\+\)}/Package-Blacklist { "*" }/g' /etc/apt/apt.conf.d/50unattended-upgrades
sed -i -e 's/Package-Whitelist {\([^}]\+\)}/Package-Whitelist { }/g' /etc/apt/apt.conf.d/50unattended-upgrades
