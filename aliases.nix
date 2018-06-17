{ config, pkgs, lib, ... } :

with lib;

{
  environment.shellAliases = {
    ll = "ls -l";
    gg = "git grep -i";
    nixpaste = "curl -F \"text=<-\" http://nixpaste.lbr.uno";
  };
}
