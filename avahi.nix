{ config, lib, pkgs, ... }:
with lib;
let cfg = config.customServices.avahi;
in { services.avahi = { enable = true; }; }
