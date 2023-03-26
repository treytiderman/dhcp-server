FROM alpine:latest
RUN apk add --no-cache dhcp
RUN ["touch", "/var/lib/dhcp/dhcpd.leases"]

# Default to listening on all interfaces
CMD ["/usr/sbin/dhcpd", "-4", "-f", "-d", "--no-pid", "-cf", "/etc/dhcp/dhcpd.conf"]

# Use a specific network interface eth0 for example
# CMD ["/usr/sbin/dhcpd", "-4", "-f", "-d", "--no-pid", "-cf", "/etc/dhcp/dhcpd.conf", "eth0"]