# ISC DHCP Server

Tested with podman on Fedora 37

Must run as root !!!

## Download

```
cd /root
git clone https://github.com/treytiderman/dhcp-server.git
```

## Build

```
cd /root/dhcp-server
podman build . -t dhcp-server
```

## Run

```
mkdir /root/dhcp-server
cd /root/dhcp-server
mkdir -p data
podman stop dhcp-server
podman rm dhcp-server
podman run -d \
	--privileged \
	--name dhcp-server \
	--network host \
	-v $(pwd)/data:/etc/dhcp:z \
	-v $(pwd)/data:/var/lib/dhcp:z \
	dhcp-server
```

### Print out DHCP leases

```
cat /root/dhcp-server/data/dhcpd.leases | grep -e lease -e "hardware ethernet" -e client-hostname
```

### Example dhcpd.conf

```dhcpd.conf
# Only DHCP server on the network
authoritative;

# Securing the DHCP server
ddns-update-style none; # Disable the dynamic DNS
deny declines; # DHCPDECLINE can be used in DoS attacks
deny bootp; # Disable support older BOOTP clients

# Subnet 192.168.1.xxx
subnet 192.168.1.0 netmask 255.255.255.0 {

	# DHCP Range
	range 192.168.1.100 192.168.1.200;
	
	# Lease Time
	default-lease-time 600; # 10min
	max-lease-time 7200; # 120min

	# Router (Optional)
	option routers           192.168.1.254;
	option subnet-mask       255.255.255.0;
	option broadcast-address 192.168.1.255;

	# DNS Servers and Name (Optional)
	option domain-name         "lan";
	option domain-search       "lan";
	option domain-name-servers 192.168.1.1, 1.1.1.1;

}

# Fixed IP addresses based on MAC Address
host fixed1 {
	hardware ethernet 00:D8:61:1A:8E:7B;
	fixed-address     192.168.1.99;
}
```

### Example dhcpd.leases

```
# The format of this file is documented in the dhcpd.leases(5) manual page.
# This lease file was written by isc-dhcp-4.4.3-P1

# authoring-byte-order entry is generated, DO NOT DELETE
authoring-byte-order little-endian;

server-duid "\000\001\000\001+\263[\326\310!X5\273\036";

lease 192.168.1.100 {
  starts 0 2023/03/26 19:43:39;
  ends 0 2023/03/26 19:53:39;
  cltt 0 2023/03/26 19:43:39;
  binding state active;
  next binding state free;
  rewind binding state free;
  hardware ethernet f4:be:ec:ba:42:be;
  uid "\001\364\276\354\272B\276";
  client-hostname "Trey-iPhone13";
}
```
