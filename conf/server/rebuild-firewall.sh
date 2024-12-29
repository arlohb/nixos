#!/bin/sh

# This is no longer used, but I'll keep it to show how this can be done.

# Flush the rules
iptables -F

# Load the new rules service
nixos-rebuild switch

# Flush the rules
iptables -F

# Apply the rules
systemctl restart firewall
systemctl restart docker
systemctl restart firewall-rules

