{ config, lib, pkgs, ...}:
with lib;
let
  cfg = config.customServices.essentials;
in
{
  options.customServices.essentials = {
    sshKey = mkOption {
      description = "Authorized ssh key";
    };
    enable = mkEnableOption "essential Program";
  };
  config = mkIf cfg.enable {
    networking.firewall = {
      enable = true;
      allowPing = true;
    };
    environment.systemPackages =
    with pkgs; [
      acpi
      aspellDicts.de
      aspellDicts.en
      bc
      bind
      btrfsProgs
      cabal2nix
      cloc
      convmv
      cowsay
      darcs
      dhcp
      disnix
      duplicity
      dysnomia
      emacsEnv
      encfs
      ethtool
      gdo-exec
      git
      gnumake
      gnupg
      gnutls
      gv
      haskellEnv
      htop
      iftop
      imagemagick
      inetutils
      iotop
      jq
      lsof
      man-pages
      mercurial
      ms-sys
      nix-prefetch-scripts
      nixops
      nmap
      nodePackages.node2nix
      ntfs3g
      openssl
      pandoc
      parallel
      pciutils
      pmutils
      pwgen
      pypiPackages2.packages.hetzner
      pypiPackages3.packages.jinja2-cli
      pypiPackages3.packages.kubecert
      pypiPackages3.packages.nix-helpers
      pypiPackages3.packages.nix-prefetch-github
      pypiPackages3.packages.parsemon2
      pypiPackages3.packages.pypi2nix
      pypiPackages3.packages.stormssh
      python3Packages.isort
      python3Packages.youtube-dl
      rfkill
      shellcheck
      skopeo
      smartmontools
      speedtest-cli
      tcpdump
      tcpflow
      telnet
      texlive.combined.scheme-full
      tinc_pre
      travis
      cachix
      unzip
      usbutils
      wavemon
      wget
      zip
    ];
    programs = {
      bash.enableCompletion = true;
      ssh.startAgent = true;
    };
    users.extraUsers = {
      sebastian = {
        isNormalUser = true;
        uid = 1000;
        extraGroups = [
          "wheel"
          "audio"
          "video"
          "networkmanager"
          "docker"
        ];
        openssh.authorizedKeys.keys =
          [ cfg.sshKey ];
      };
      root.openssh.authorizedKeys.keys =
        [ cfg.sshKey ];
    };
    nix.useSandbox = true;
    nix.sandboxPaths = [
      "/etc/ssl/certs/ca-certificates.crt"
    ];
    nixpkgs.config.allowUnfree = true;
    services.openssh.enable = true;
  };
}
