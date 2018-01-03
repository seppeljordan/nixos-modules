{ config, lib, pkgs, ...}:
{
  imports = [
    ./overlays.nix
  ];
  networking.firewall = {
    enable = true;
    allowPing = true;
  };
  environment.systemPackages =
  with pkgs; [
    inetutils
    acpi
    aspellDicts.de
    aspellDicts.en
    bc
    bind
    btrfsProgs
    cabal2nix
    cloc
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
    haskellPackages.update-tool
    htop
    iftop
    imagemagick
    iotop
    jq
    lsof
    man-pages
    mercurial
    nix-prefetch-scripts
    nix-repl
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
    pypiPackages3.packages.pypi2nix
    pypiPackages3.packages.stormssh
    python3Packages.isort
    python3Packages.youtube-dl
    rfkill
    shellcheck
    smartmontools
    speedtest-cli
    tcpdump
    tcpflow
    telnet
    texlive.combined.scheme-full
    tinc_pre
    unzip
    wavemon
    wget
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
      openssh.authorizedKeys.keyFiles =
        [ ../../../.ssh/private_rsa.pub ];
    };
    root.openssh.authorizedKeys.keys =
      [ (builtins.readFile ../../../.ssh/private_rsa.pub) ];
  };
  nix.useSandbox = true;
  nix.sandboxPaths = [
    "/etc/ssl/certs/ca-certificates.crt"
  ];
  nixpkgs.config.allowUnfree = true;
  services.openssh.enable = true;

}
