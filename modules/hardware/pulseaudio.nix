{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.pulseaudio;
in {
  options.modules.hardware.pulseaudio = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    sound.enable = true;
    hardware.pulseaudio.enable = true;
    # Disable NoiseTorch until it is safe to install again
    # user.packages = with pkgs; [
      # unstable.noisetorch
      # (makeDesktopItem {
        # name = "noisetorch";
        # desktopName = "NoiseTorch";
        # genericName = "Virtual Microphone";
        # icon = "microphone";
        # exec = "${noisetorch}/bin/noisetorch";
        # categories = [ "Audio" ];
      # })
    # ];

    user.packages = with pkgs; [
      # PulseAudio Preferences GUI
      paprefs
    ];

    # HACK Prevents ~/.esd_auth files by disabling the esound protocol module
    #      for pulseaudio, which I likely don't need. Is there a better way?
    hardware.pulseaudio.configFile =
      let inherit (pkgs) runCommand pulseaudio;
          paConfigFile =
            runCommand "disablePulseaudioEsoundModule"
              { buildInputs = [ pulseaudio ]; } ''
                mkdir "$out"
                cp ${pulseaudio}/etc/pulse/default.pa "$out/default.pa"
                sed -i -e 's|load-module module-esound-protocol-unix|# ...|' "$out/default.pa"
              '';
      in mkIf config.hardware.pulseaudio.enable
        "${paConfigFile}/default.pa";

    user.extraGroups = [ "audio" ];
  };
}
