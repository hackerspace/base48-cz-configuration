{ config, lib, pkgs, ...}:

with lib;
{

  imports = [
    ./modules/bird.nix
    ./common.nix
  ];

  networking.hostName = "ci";
  networking.dhcp = true;

  boot.zfs.pools = {
    tank = {
      #doCreate = true;
      install = true;
      wipe = [ "sda" "sdb" "sdc" "sdd" "sde" "sdf" ];
      layout = [
        { type = "mirror"; devices = [ "sda" "sdb" ]; }
        { type = "mirror"; devices = [ "sdc" "sdd" ]; }
        { type = "mirror"; devices = [ "sde" "sdf" ]; }
      ];
    };
  };

  #boot.kernelParams = [ "console=tty0" "console=ttyS0,115200" "panic=-1" ];
  boot.consoleLogLevel = 4;

  node.routerId = "172.17.6.240";
  node.bfdInterfaces = "eth*";
  node.as = 4266600240;
}
