#!/bin/sh

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

