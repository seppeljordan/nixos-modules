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
      ansible
      bc
      bind
      binutils
      btrfsProgs
      cabal2nix
      cachix
      cargo
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
      gcc
      gdo-exec
      git
      gnumake
      gnupg
      gnutls
      gv
      haskellEnv
      hfsprogs
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
      nix-prefetch-github
      nix-prefetch-scripts
      nixops
      nmap
      nodePackages.node2nix
      ntfs3g
      openssl
      pandoc
      parallel
      pciutils
      pip-test-env
      pkgconfig
      pmutils
      pwgen
      pypiPackages2.packages.hetzner
      pypiPackages3.packages.jinja2-cli
      pypiPackages3.packages.kubecert
      pypiPackages3.packages.parsemon2
      pypiPackages3.packages.pypi2nix
      pypiPackages3.packages.stormssh
      python3Packages.isort
      python3Packages.virtualenv
      python3Packages.youtube-dl
      rfkill
      rustc
      rustfmt
      rustracer
      shellcheck
      skopeo
      smartmontools
      speedtest-cli
      subversion
      tcpdump
      tcpflow
      telnet
      texlive.combined.scheme-full
      tinc_pre
      travis
      unzip
      usbutils
      wavemon
      wget
      woeusb
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
