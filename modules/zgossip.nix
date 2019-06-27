{ lib, config, pkgs, ... }:
let
  #zre = pkgs.haskell.packages.ghc822.zre;
  zre = import /home/rmarko/git/zre {};
in
{
   environment.systemPackages = [ zre ];

   networking.firewall.allowedTCPPorts = [ 31337 ];

   systemd.services.zgossip =
     { description = "ZGossip server";
       wantedBy = [ "multi-user.target" ];
       after = [ "network.target" ];
       serviceConfig =
         { ExecStart = "${zre}/bin/zgossip_server";
           Restart = "always";
           RestartSec = 3;
         };
     };
}
