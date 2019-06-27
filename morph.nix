let
  # Pin the deployment package-set to a specific version of nixpkgs
  newPkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs-channels/archive/180aa21259b666c6b7850aee00c5871c89c0d939.tar.gz";
    sha256 = "0gxd10djy6khbjb012s9fl3lpjzqaknfv2g4dpfjxwwj9cbkj04h";
  }) {};

  legacyPkgs = builtins.fetchTarball {
    url    = "https://d3g5gsiof5omrk.cloudfront.net/nixos/17.09/nixos-17.09.3243.bca2ee28db4/nixexprs.tar.xz";
    sha256 = "1adi0m8x5wckginbrq0rm036wgd9n1j1ap0zi2ph4kll907j76i2";
  };

  pinned = import ./pinned.nix { inherit (newPkgs) lib pkgs; };
in
{
  network =  {
    pkgs = newPkgs;
    description = "base48 hosts";
  };

  # uses network.pkgs
  "pxe.base48.cz" = { config, pkgs, ... }: with pkgs; {
    imports = [
      ./env.nix
      ./machines/pxe.nix
      ./profiles/kvm.nix
      <nixpkgs/nixos/modules/profiles/minimal.nix>
    ];
    boot.kernelParams = [
      "net.ifnames=0"
    ];

    # 52:54:00:da:36:36
    networking = {
      nameservers = [
        #"2001:4860:4860::8888"
        #"2a03:3b40:7:6:9000::1"
        "172.17.6.254"
        "37.205.9.100" # vpsf
        "37.205.10.88" # vpsf2
      ];
      defaultGateway = "172.17.6.1";
      defaultGateway6 = "2a03:3b40:7:6::";
      interfaces = {
        eth0 = {
          ipv4.addresses = [
            { address="172.17.6.254"; prefixLength=24; }
          ];
          ipv6.addresses = [
            { address="2a03:3b40:7:6:9000::1"; prefixLength=80; } # new
          ];
        };

      };
    };

    boot.loader.grub.device = "/dev/vda";

    boot.zfs.devNodes = "/dev/disk/by-uuid";
    networking.hostId = "0000EE99";
    boot.supportedFilesystems = [ "zfs" ];

    fileSystems."/" =
    { device = "tank/root";
      fsType = "zfs";
    };

    deployment = {
      healthChecks = {
        http = [
          {
            scheme = "http";
            port = 80;
            path = "/";
            description = "Check whether nginx is running.";
            period = 1; # number of seconds between retries
          }
        ];
      };
    };
  };

  "devnode1.base48.cz" = { config, pkgs, ... }: with pkgs; {
    imports = [
      ./nodes/devnode1.nix
    ];

    nixpkgs.overlays = [
      (import "${pinned.vpsadminosSrc}/os/overlays/vpsadmin.nix" pinned.vpsadminSrc)
    ];

    deployment = {
      nixPath = [
        { prefix = "nixpkgs"; path = pinned.nixpkgsVpsFreeSrc; }
        { prefix = "vpsadminos"; path = pinned.vpsadminosSrc; }
      ];
      importPath = "${pinned.vpsadminosSrc}/os/default.nix";
    };
  };
}
