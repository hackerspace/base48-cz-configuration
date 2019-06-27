{ lib, config, pkgs, ... }:
{
  networking.firewall.allowedUDPPorts = [ 53 ];
  networking.firewall.allowedTCPPorts = [ 53 ];

  services.bind = {
    enable = true;
    forwarders = [ "172.18.2.10" ];
    cacheNetworks = [ "any" ];
  };
}
