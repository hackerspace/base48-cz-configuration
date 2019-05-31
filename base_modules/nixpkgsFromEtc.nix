{ config, lib, ... } :
with lib;
{
  options = {
    base.nixpkgsFromEtc.enable = mkEnableOption "Use nixpkgs from /etc/nixpkgs";
  };

  config = mkIf config.base.nixpkgsFromEtc.enable {
    nix.nixPath = [ "nixpkgs=/etc/nixpkgs" ];
  };
}

