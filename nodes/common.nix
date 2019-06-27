{ config, lib, pkgs, ...}:
{

  imports = [
    # XXX
    # /home/rmarko/git/vpsadminos/os/modules/channel.nix
  ];
  #tty.autologin.enable = true;
  #users.users.root.initialHashedPassword = "$6$AOZFDbq4EDX3p$tjWxIS9/0ZcF6/Q30LtMB0/2sAz6taxbUTtraVLVOe7zORC7AernhNWbgLBj9OAZh1wTMhd1BW9NmIU9d7gj3.";
  users.users.root.openssh.authorizedKeys.keys =
    let
      sshKeys = import ../ssh-keys.nix;
    in [
      sshKeys.aither
      sshKeys.srk
      sshKeys.snajpa
    ];
  users.users.root.initialHashedPassword = "$6$ZcSMYnJK/9r$zLWCbDdJ9FG0Dy0fxEye91FYEPrA47tQ.2Al9LOIL3QoSG5kJRzaguvLcKjhls3sPK5mLYHUddNj2V0iCM4Rm/";

  boot.kernelModules = [
    "ipmi_si"
    "ipmi_devintf"
  ];

  boot.extraModulePackages = [ config.boot.kernelPackages.wireguard ];

  vpsadminos.nix = true;
  environment.systemPackages = with pkgs; [
    dmidecode
    ipmicfg
    lm_sensors
    vim
    pciutils
    screen
    smartmontools
    usbutils
    iotop
    ledmon

    config.boot.kernelPackages.bpftrace
    #dstat # broken ..

    strace
    wireguard
    wireguard-tools
  ];

  # to be able to include ipmicfg
  nixpkgs.config.allowUnfree = true;

  networking = {
    domain = "base48.cz";
    search = ["vpsfree.cz" "prg.vpsfree.cz" "base48.cz"];
    nameservers = [ "172.17.6.254" "172.18.2.10" "172.18.2.11" "1.1.1.1" ];
  };

  services.nfs.server.enable = true;
  services.prometheus.node_exporter.enable = true;
  # services.rsyslogd.forward = [ "172.17.1.245:11514" ];

  programs.bash.root.historyPools = [ "tank" ];
  programs.bash.promptInit = ''
    # Provide a nice prompt if the terminal supports it.
    if [ "$TERM" != "dumb" -o -n "$INSIDE_EMACS" ]; then
      PROMPT_COLOR="1;31m"
      let $UID && PROMPT_COLOR="1;32m"
      PS1="\n\[\033[$PROMPT_COLOR\][\u@\H:\w]\\$\[\033[0m\] "
      if test "$TERM" = "xterm"; then
        PS1="\[\033]2;\h:\u:\w\007\]$PS1"
      fi
    fi
  '';

  osctl.pools.tank = {
    parallelStart = 2;
    parallelStop = 4;
  };

  environment.etc =
  let prefix = ../static/nodes;
      copy = pkgs.copyPathToStore prefix;
      path = "${ copy }/${ config.networking.hostName }/ssh";
  in
  {
    "ssh/ssh_host_rsa_key.pub".source = "${ path }/ssh_host_rsa_key.pub";
    "ssh/ssh_host_rsa_key" = { mode = "0600"; source = "${ path }/ssh_host_rsa_key"; };
    "ssh/ssh_host_ed25519_key.pub".source = "${ path }/ssh_host_ed25519_key.pub";
    "ssh/ssh_host_ed25519_key" = { mode = "0600"; source = "${ path }/ssh_host_ed25519_key"; };
  };

  services.zfs.autoScrub = {
    enable = true;
    interval = "0 4 */14 * *"; # date time format for cron (NixOS uses systemd calendar format)
    pools = [];                # scrub all pools
  };
}
