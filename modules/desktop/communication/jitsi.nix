{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.communication.jitsi;
in {
  options.modules.desktop.communication.jitsi = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      jitsi-meet-electron
    ];
  };
}
