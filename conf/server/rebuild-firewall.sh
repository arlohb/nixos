#!/bin/sh

iptables -F
nixos-rebuild switch
iptables -F
systemctl restart firewall
systemctl restart docker
systemctl restart firewall-rules

