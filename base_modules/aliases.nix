{ config, pkgs, lib, ... } :

with lib;

{
  environment.shellAliases = {
    ll = "ls -l";
    gg = "git grep -i";
    nrb = "nixos-rebuild build";
    nrs = "nixos-rebuild switch";
    vi = "vim";
    psg = "ps axuf | grep -i";
    nixpaste = "curl -F \"text=<-\" http://nixpaste.lbr.uno";
  };
}
