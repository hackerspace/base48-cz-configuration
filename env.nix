{ config, pkgs, ... }:
{
  time.timeZone = "Europe/Amsterdam";
  networking = {
    domain = "base48.cz";
    search = ["vpsfree.cz" "prg.vpsfree.cz" "base48.cz"];
    nameservers = [ "172.17.6.254" "172.18.2.10" "172.18.2.11" "1.1.1.1" ];
  };


  services.openssh.enable = true;
  nix.useSandbox = true;

  imports = [
    ./modules/monitored.nix
  ];

  environment.systemPackages = with pkgs; [
    wget
    vim
    screen
  ];

  users.extraUsers.root.openssh.authorizedKeys.keys =
    with import ./ssh-keys.nix; [ srk snajpa ];
}
