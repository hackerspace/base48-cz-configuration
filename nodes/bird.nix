{ config, lib, pkgs, ...}:

with lib;

let
  cfg = config.node.bgp;

  # peer AS
  bgpAS = 4266600001;

  kernelProto = {
      learn = true;
      persist = true;
      extraConfig = ''
        export all;
        import all;
        import filter {
          if net.len > 25 then accept;
          reject;
        };
      '';
    };
in
{
  options = {
    node.bgp = {
      routerId = mkOption {
        type = types.str;
      };

      as = mkOption {
        type = types.ints.positive;
      };
    };
  };

  config = {
    networking.bird = {
      enable = true;
      routerId = cfg.routerId;
      protocol.kernel = kernelProto;
      protocol.bgp = {
        bgp1 = rec {
          as = cfg.as;
          nextHopSelf = true;
          neighbor = { "172.17.6.1" = bgpAS; };
          extraConfig = ''
            export all;
            import all;
          '';
        };
      };
    };

    networking.bird6 = {
      enable = true;
      routerId = cfg.routerId;
      protocol.kernel = kernelProto;
      protocol.bgp = {
        bgp1 = rec {
          as = cfg.as;
          nextHopSelf = true;
          neighbor = { "2a03:3b40:7:6::1" = bgpAS; };
          extraConfig = ''
            export all;
            import all;
          '';
        };
      };
    };
  };
}
