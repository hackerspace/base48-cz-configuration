{ lib, config, pkgs, ... }:
{
  # 10 ci_mgmt, switchport GE??
  # 11 devnode1_mgmt, switchport GE35
  # 21 panzer1_mgmt, switchport GE41
  # 22 panzer2_mgmt, switchport GE42

  # 172.17.6.100 - 199 DHCP
  # 172.17.6.200 -
  # 172.17.6.201 node1
  # 172.17.6.202 node2
  # 172.17.6.206 node6

  # 220 srk_nixos
  # 221 lada_nixops

  # 230 devadmin
  # 231 devnode1

  # 240 ci
  # 241 panzer1, switchport GE43
  # 242 panzer2, switchport GE47

  # 254 DNS, DHCP, IPXE

  # CTs
  # 172.17.166.10 scylla     @ci

  # builders
  # 172.17.66.10  builder00  @devnode

  # mon
  # 172.17.66.66  mon0       @devnode

  networking.firewall.allowedUDPPorts = [ 67 ];

  services.dhcpd4 = {
    enable = true;
    interfaces = [ "eth0" ];
    extraConfig = ''
      authoritative;

      option routers 172.17.6.1;
      option broadcast-address 172.17.6.255;
      option subnet-mask 255.255.255.0;

      option domain-name-servers 172.17.6.254, 37.205.9.100, 37.205.10.88, 1.1.1.1;

      next-server 172.17.6.254;
      #filename "ipxe.lkrn";
      filename "pxelinux.0";

      #default-lease-time -1;
      #max-lease-time -1;

      subnet 172.17.6.0 netmask 255.255.255.0 {
        range 172.17.6.100 172.17.6.199;
      }
      #host vpn { hardware ethernet 52:54:00:60:bc:5e; fixed-address 172.17.6.11; }

    '';

    machines = [
      { ethernetAddress = "52:54:00:83:3d:b2"; hostName = "srk_nixos"; ipAddress = "172.17.6.220"; }
      { ethernetAddress = "52:54:00:5e:92:f3"; hostName = "lada_nixops"; ipAddress = "172.17.6.221"; }

      # hwnodes
      { ethernetAddress = "00:25:90:c9:d4:d6"; hostName = "devnode1"; ipAddress = "172.17.6.231"; }

      # hwnodes/ci
      { ethernetAddress = "00:25:90:57:6c:de"; hostName = "ci"; ipAddress = "172.17.6.240"; }

      # builders
      { ethernetAddress = "00:25:90:70:b8:96"; hostName = "panzer1"; ipAddress = "172.17.6.241"; }
      { ethernetAddress = "00:25:90:70:b8:9a"; hostName = "panzer2"; ipAddress = "172.17.6.242"; }

      # mgmt
      { ethernetAddress = "00:25:90:57:69:89"; hostName = "ci_mgmt"; ipAddress = "172.17.6.10"; }
      { ethernetAddress = "00:25:90:ce:35:8c"; hostName = "devnode1_mgmt"; ipAddress = "172.17.6.11"; }

      # mgmt/builders
      { ethernetAddress = "00:25:90:70:b7:51"; hostName = "panzer1_mgmt"; ipAddress = "172.17.6.21"; }
      { ethernetAddress = "00:25:90:70:b7:53"; hostName = "panzer2_mgmt"; ipAddress = "172.17.6.22"; }

      #{ ethernetAddress = ""; hostName = ""; ipAddress = "172.17.6."; }
    ];
  };

  services.dhcpd6 = {
    enable = true;
    interfaces = [ "eth0" ];
    extraConfig = ''
      authoritative;

      subnet6 2a03:3b40:7:6:9000::/80 {
        range6 2a03:3b40:7:6:9000::/80;
        #range6 2a03:3b40:7:6:8000::100 2a03:3b40:7:6:8000::200;
        # option dhcp6.name-servers 2a01:4f8:0:1::add:1010, 2a01:4f8:0:1::add:9999, 2a01:4f8:0:1::add:9898;
        # option dhcp6.gateway 2a03:3b40:7:5::/64;
      }
    '';
  };
}
