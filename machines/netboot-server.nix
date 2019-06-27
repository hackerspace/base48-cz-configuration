{ lib, config, pkgs, ... }:

### XXX: OBSOLETE, UNUSED, port to images.nix

with lib;

let
  pinned = import ../pinned.nix { inherit lib pkgs; };

  nixosBuild = {modules ? []}:
    (import (pkgs.path + "/nixos/lib/eval-config.nix") {
      system = "x86_64-linux";
      modules = [
        (pkgs.path + "/nixos/modules/installer/netboot/netboot-minimal.nix")
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

  # due to overlayfs
  nixosBuildSrk = {modules ? []}:
    (import (pinned.nixpkgsSorki.path + "/nixos/lib/eval-config.nix") {
      system = "x86_64-linux";
      modules = [
        # VERY ERROR PRONE REPETITION
        (pinned.nixpkgsSorki.path + "/nixos/modules/installer/netboot/netboot-minimal.nix")
      ] ++ modules;
    }).config.system.build;

  nixosNetbootSrk = {modules ? []}:
    let
      build = nixosBuildSrk { inherit modules; };
    in {
      toplevel = build.toplevel;
      dir = pkgs.symlinkJoin {
        name = "nixos_netboot_srk";
        paths = with build; [ netbootRamdisk kernel netbootIpxeScript ];
      };
    };

  node = {modules ? []}:
    let
      common = {
          imports = [
            "${pinned.vpsadminosGit}/os/configs/common.nix"
            # "${pinned.vpsadminosSrc}/os/configs/common.nix"
      ]; };
      build = pinned.vpsadminosBuild {  modules = modules ++ [common]; };
    in {
      toplevel = build.toplevel;
      kernelParams = build.kernelParams;
      dir = pkgs.symlinkJoin {
        name = "vpsadminos_netboot";
        paths = with build; [ dist ];
      };
    };

  nodeArmv7 = {modules ? []}:
    let
      build = pinned.vpsadminosBuildArmv7 { inherit modules; };
    in {
      toplevel = build.toplevel;
      kernelParams = build.kernelParams;
      dir = pkgs.symlinkJoin {
        name = "vpsadminos_netboot_armv7";
        paths = with build; [ dist ];
      };
    };

  # stock NixOS
  nixos = nixosNetboot { };
  nixosZfs = nixosNetboot {
    modules = [ {
        boot.supportedFilesystems = [ "zfs" ];
      } ];
  };

  nixosZfsSSH = nixosNetboot {
    modules = [ {
        imports = [ ../env.nix ];
        boot.supportedFilesystems = [ "zfs" ];
        # enable ssh
        systemd.services.sshd.wantedBy = lib.mkForce [ "multi-user.target" ];
        system.stateVersion = pkgs.lib.mkDefault "master";
      } ];
  };

  panzer1 = nixosNetbootSrk {
    modules = [ {
        imports = [
          ../env.nix
          ../hydra-slave.nix
        ];

        networking.hostName = "panzer1";

        systemd.services.sshd.wantedBy = lib.mkForce [ "multi-user.target" ];

        services.openssh.hostKeys = [ { type = "ed25519"; path = "/etc/ssh/ssh_host_ed25519_key"; } ];
        # disable installer feats
        services.mingetty.autologinUser = lib.mkForce null;
        services.nixosManual.showManual = lib.mkForce false;


        # mkdir static/panzerX; ssh-keygen -t ed25519 -f "static/panzerX/hostkey" -N ""
        environment.etc = {
          "ssh/ssh_host_ed25519_key" = { mode = "0600"; source = ../static/panzer1/hostkey; };
          "ssh/ssh_host_ed25519_key.pub".source = ../static/panzer1/hostkey.pub;
        };
    } ];
  };

  panzer2 = nixosNetbootSrk {
    modules = [ {
        imports = [
          ../env.nix
          ../hydra-slave.nix
        ];

        networking.hostName = "panzer2";

        systemd.services.sshd.wantedBy = lib.mkForce [ "multi-user.target" ];

        services.openssh.hostKeys = [ { type = "ed25519"; path = "/etc/ssh/ssh_host_ed25519_key"; } ];
        # disable installer feats
        services.mingetty.autologinUser = lib.mkForce null;
        services.nixosManual.showManual = lib.mkForce false;


        # mkdir static/panzerX; ssh-keygen -t ed25519 -f "static/panzerX/hostkey" -N ""
        environment.etc = {
          "ssh/ssh_host_ed25519_key" = { mode = "0600"; source = ../static/panzer2/hostkey; };
          "ssh/ssh_host_ed25519_key.pub".source = ../static/panzer2/hostkey.pub;
        };
    } ];
  };

  # stock vpsAdminOS
  vpsadminos = node {
    modules = [ {
      imports = [
        # "${pinned.vpsadminosGit}/os/configs/default.nix"
      ];
    } ];
  };

  # node configurations
  devnode1 = node {
    modules = [ {

      imports = [
        ../nodes/devnode1.nix
      ];

    } ];
  };

  node1 = node {
    modules = [ {

      imports = [
        ../nodes/node1.nix
      ];

    } ];
  };
  ci = node {
    modules = [ {

      imports = [
        ../nodes/ci.nix
      ];

    } ];
  };

  arm = nodeArmv7 {
    modules = [ {

      imports = [
        ../nodes/armtest.nix
      ];


    } ];
  };

  inMenu = name: netbootitem: netbootitem // { menu = name; };
in {
  imports = [
    ../modules/netboot.nix
  ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  networking.firewall.allowedUDPPorts = [ 68 69 ];

  netboot.host = lib.mkDefault "netboot";
  netboot.password = lib.mkDefault "letmein";
  netboot.nixos_items = {
  /*
    nixos = inMenu "NixOS" nixos;
    nixoszfs = inMenu "NixOS ZFS" nixosZfs;
    nixoszfsssh = inMenu "NixOS ZFS SSH" nixosZfsSSH;
  */
    inherit panzer1;
    inherit panzer2;
  };
  netboot.vpsadminos_items = {
    #vpsadminos = inMenu "vpsAdminOS" vpsadminos;
    inherit devnode1;
    inherit ci;
    #inherit arm;
  };

  netboot.mapping = {
    # "00:25:90:57:6c:de" = "ci";
    "00:25:90:c9:d4:d6" = "devnode1";
    # "00:25:90:55:53:04" = "node1";
    # "00:25:90:55:53:05" = "node1";
    # "00:25:90:70:b8:96" = "panzer1";
    # "00:25:90:70:b8:9a" = "panzer2";
  };

}
