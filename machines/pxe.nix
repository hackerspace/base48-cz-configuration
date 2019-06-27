{ config, pkgs, lib, ... }:
let
  images = import ../images.nix { inherit lib pkgs; };

  # repoName=vpsfree-cz-configuration rev=xyz; nix-prefetch-url --unpack "https://github.com/vpsfreecz/${repoName}/archive/${rev}.tar.gz"
  vpsfczConfRev = "437e54575b9a088eeb9bfbb10263779a3a1c33b6";
  vpsfczConf = builtins.fetchTarball {
    url = "https://github.com/vpsfreecz/vpsfree-cz-configuration/archive/${vpsfczConfRev}.tar.gz";
    sha256 = "0fm48b64knqvd07ryr7spx0hfcz8mffmjcz2y4181gn4w10ns9a2";
  };
in
{
  imports = [
    "${vpsfczConf}/modules/netboot.nix"

    ../modules/dhcp.nix
    ../modules/dns.nix
  ];

  netboot = {
    host = "172.17.6.254";
    inherit (images) nixosItems vpsadminosItems mappings;
    includeNetbootxyz = true;
    secretsDir = ../static/ca;
  };
}
