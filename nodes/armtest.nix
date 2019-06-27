{ config, lib, pkgs, ...}:
{

  # imports = [ ./common.nix ];

  networking.hostName = "armtest";
  networking.dhcp = true;

  boot.zfs.pools = {
    tank = {
      doCreate = true;
      install = true;
      wipe = [ "sda" ];
      layout = "sda";
    };
  };

  boot.kernelParams = [ "console=ttymxc1,115200" "panic=-1" ];
  boot.consoleLogLevel = 4;

  environment.systemPackages = with pkgs; [
    #obs-studio
    wayland
    can-utils
  ];
}
