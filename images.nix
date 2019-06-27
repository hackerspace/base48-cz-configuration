{ pkgs, lib, ... }:

with lib;

rec {
  pinned = import ./pinned.nix { inherit lib pkgs; };

  nixosBuild = {modules ? []}:
    (import (pinned.nixpkgsVpsFree.path + "/nixos/lib/eval-config.nix") {
      system = "x86_64-linux";
      modules = [
        (pinned.nixpkgsVpsFree.path + "/nixos/modules/installer/netboot/netboot-minimal.nix")
      ] ++ modules;
    }).config.system.build;

  nixosNetboot = {modules ? []}:
    let
      build = nixosBuild { inherit modules; };
    in {
      toplevel = build.toplevel;
      dir = pkgs.symlinkJoin {
        name = "nixos_netboot";
        paths = with build; [ netbootRamdisk kernel netbootIpxeScript ];
      };
    };

  node = {modules ? []}:
    let
      build = pinned.vpsadminosBuild { inherit modules; };
    in {
      toplevel = build.toplevel;
      kernelParams = build.kernelParams;
      dir = pkgs.symlinkJoin {
        name = "vpsadminos_netboot";
        paths = with build; [ dist ];
      };
    };

  vpsadminosISO =
    let
      build = pinned.vpsadminosBuild {
        modules = [{
          imports = [
            "${pinned.vpsadminosSrc}/os/configs/iso.nix"
          ];

          system.secretsDir = null;
        }];
      };
    in build.isoImage;

  inMenu = name: netbootitem: netbootitem // { menu = name; };

  # stock NixOS
  nixos = nixosNetboot { };
  nixosZfs = nixosNetboot {
    modules = [ {
        boot.supportedFilesystems = [ "zfs" ];
      } ];
  };

  nixosZfsSSH = nixosNetboot {
    modules = [ {
        imports = [ ./env.nix ];
        boot.supportedFilesystems = [ "zfs" ];
        # enable ssh
        systemd.services.sshd.wantedBy = lib.mkForce [ "multi-user.target" ];
      } ];
  };

  # stock vpsAdminOS
  vpsadminos = node { };

  # node configurations
  devnode1 = node {
    modules = [ {

      imports = [
        ./nodes/devnode1.nix
      ];

    } ];
  };

  macMap = {
    devnode1 = [
      "00:25:90:c9:d4:d6"
    ];
  };

  # netboot.mappings is in form { "MAC1" = "nodeX"; "MAC2" = "nodeX"; }
  mappings = lib.listToAttrs (lib.flatten (lib.mapAttrsToList (x: y: map (mac: lib.nameValuePair mac x) y) macMap));

  nixosItems = {
    #nixos = inMenu "NixOS" nixos;
    #nixoszfs = inMenu "NixOS ZFS" nixosZfs;
    #nixoszfsssh = inMenu "NixOS ZFS SSH" nixosZfsSSH;
  };

  vpsadminosItems = {
    inherit devnode1;
  };
}
