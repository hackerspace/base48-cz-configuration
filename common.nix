{ config, pkgs, lib, ...}:
with lib;
{
  time.timeZone = mkDefault "Europe/Amsterdam";
  services.openssh.enable = mkDefault true;

  services.tor.client.enable = mkDefault true;
  programs.bash.enableCompletion = mkDefault true;

  environment.systemPackages = with pkgs; [
    wget
    curl
    vim
    screen
  ];
}
