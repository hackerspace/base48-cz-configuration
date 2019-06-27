{ config, lib, pkgs, ...}:
let
  bondIfaces = [ "eth0" "eth1" ];
  bondVlan = 200;
  bondIP = "172.17.6.231/23";
  bondGateway = "172.17.6.1";
in
{

  imports = [
    ./bird.nix
    ./common.nix
  ];

  networking.hostName = "devnode1";
  #networking.dhcp = true;
  boot.kernelModules = [ "bonding" "8021q" ];
  boot.extraModprobeConfig = "options bonding mode=balance-xor miimon=100 xmit_hash_policy=layer3+4 max_bonds=0";

  networking.custom = ''
    ip link add bond0 type bond
    ${lib.flip lib.concatMapStrings bondIfaces (ifc:
      ''
        ip link set ${ifc} master bond0
      ''
    )}
    ip link set bond0 up

    ip addr add ${bondIP} dev bond0
    ip route add default via ${bondGateway} dev bond0
  '';


  boot.zfs.pools = {
    tank = {
      layout = [
        { type = "mirror"; devices = [ "sda" "sdb" ]; }
      ];
      doCreate = true;
      install = true;

      datasets."/".properties =  {
        acltype = "posixacl";
        compression = "on";
      };
    };
  };

  boot.kernelParams = [ "console=tty0" "console=ttyS0,115200" "panic=-1" ];
  boot.consoleLogLevel = 4;

  node.bgp.routerId = "172.17.6.231";
  node.bgp.as = 4266600231;
}
