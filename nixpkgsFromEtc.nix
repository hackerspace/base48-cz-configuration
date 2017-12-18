{ config, lib, ... } :
{
  nix.nixPath = [ "/etc" "nixos-config=/etc/nixos/configuration.nix" ];
  nix.useSandbox = true;
  nix.maxJobs = lib.mkDefault 8;
}

