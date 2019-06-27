{ config, lib, pkgs, ...}:
{

  imports = [ ./common.nix ];

  networking.hostName = "node1";
  networking.dhcp = true;

  boot.zfs.pools = {
    tank = {
      doCreate = true;
      install = true;
      wipe = [ "sda" "sdb" "sdc" "sdd" ];
      layout = "raidz sdb sdc sdd";
      logs = "sda1";
      caches = "sda2";
      partition = {
        sda = {
          p1 = { sizeGB = 10; };
          p2 = { };
        };
      };
    };
  };

  boot.kernelParams = [ "console=tty0" "console=ttyS0,115200" "panic=-1" ];
  boot.consoleLogLevel = 4;

  node.bgp.routerId = "172.17.6.201";
  node.bgp.as = "4266600201";
}
