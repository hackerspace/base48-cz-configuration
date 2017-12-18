{ config, pkgs, lib, ...}:

{
  time.timeZone = lib.mkDefault "Europe/Amsterdam";

  services.tor.client.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    curl
    vim
    screen
  ];
}
