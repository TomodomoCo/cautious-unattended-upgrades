#!/bin/bash
PATH="/usr/local/bin:${PATH}"

/usr/bin/env ruby -I/usr/local/cautious_unattended_upgrades/lib /usr/local/bin/run-cuu.rb

