{ lib, config, pkgs, ... }:

with lib;

let
  zre = import /home/rmarko/git/zre {};
  app = import /home/rmarko/git/zre-serial { inherit zre; };

  zreEnv = pkgs.writeText "zre-env" ''
    [zre]
    name = devnode1console
    gossip = zgossip.base48.cz:31337
    #interface =
    #multicast-group = IP:PORT
    debug = true

    #quiet-period  = 5  # in seconds
    #dead-period   = 10 # in seconds
    #beacon-period = 1  # in seconds
  '';
in
{
  imports = [
    ../modules/zgossip.nix
  ];

  networking.firewall.allowedTCPPortRanges = [ { from = 41000; to = 41100; } ];
  networking.firewall.allowedUDPPorts = [ 5670 ];

  systemd.services.devnode1console = {
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    environment.ZRECFG = zreEnv;
    path = [ pkgs.iproute ];
    serviceConfig =
      { Restart = "always";
        RestartSec = 3;
        Type = "simple";
        ExecStart = "${app}/bin/zre2serial /dev/ttyUSB0 115200";
      };
  };
}
