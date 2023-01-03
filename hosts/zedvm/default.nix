{ ... }:

{
  imports = [
    ../personal.nix
    ./hardware-configuration.nix
    ./mounts.nix
    ./home.nix
  ];

  ## Modules
  modules = {
    desktop = {
      gaming = {
        retro.enable = false;
        steam.enable = false;
      environments = {
        bspwm.enable = true;
        hyprland.enable = false;
        kde-plasma.enable = false;
      };
      clipboard.enable = true;
      documents.enable = false;
      fonts.enable = true;
      flatpak.enable = false;
      fm.enable = false;
      keepassxc.enable = false;
      kvantum.enable = false;
      mail.enable = false;
      plank.enable = false;
      screenshot.enable = true;
      mapping.enable = false;
      apps = {
        anki.enable = false;
        blender.enable = false;
        calibre.enable = false;
        ide.enable = false;
        ghostwriter.enable = false;
        godot.enable = false;
        gpa.enable = false;
        gsmartcontrol.enable = false;
        nextcloud.enable = false;
        rofi.enable = true;
        torrent.enable = false;
        vscodium.enable = false;
      };
      browsers = {
        default = "firefox";
        chromium.enable = false;
        firefox.enable = true;
        lynx.enable = false;
        tor.enable = false;
      };
      communication = {
        delta.enable = false;
        discord.enable = false;
        jitsi.enable = false;
        matrix.enable = false;
        signal.enable = false;
        telegram.enable = false;
      };
      media = {
        audio.enable = true;
        daw.enable = false;
        graphics.enable = true;
        kodi.enable = false;
        ncmpcpp.enable = false;
        video = {
          editing.enable = false;
          player.enable = false;
          recording.enable = false;
          transcoding.enable = false;
        };
      };
      term = {
        default = "kitty";
        st.enable = true;
        kitty.enable = true;
      };
      vm = {
        vmware.enable = false;
        qemu.enable = false;
        virtualbox.enable = false;
        virt-manager.enable = false;
      };
    };
    dev = {
      cc.enable = false;
      clojure.enable = false;
      common-lisp.enable = false;
      db.enable = false;
      go.enable = false;
      java.enable = false;
      julia.enable = false;
      lua.enable = false;
      node.enable = false;
      python.enable = false;
      rust.enable = false;
      scala.enable = false;
    };
    editors = {
      default = "vim";
      helix.enable = false;
      micro.enable = false;
      vim.enable = true;
    };
    hardware = {
      audio.enable = true;
      bluetooth.enable = false;
      disks.enable = false;
      fancontrol.enable = false;
      keebs.enable = false;
      nvidia.enable = false;
      printers.enable = false;
      sensors.enable = false;
      steamcon.enable = false;
      wacom.enable = false;
    };
    shell = {
      archive.enable = false;
      borg.enable = false;
      clipboard.enable = true;
      direnv.enable = true;
      git.enable = true;
      gnupg.enable = false;
      iperf.enable = false;
      lf.enable = false;
      aerc.enable = false;
      pass.enable = false;
      taskell.enable = false;
      zsh.enable = true;
      cli.enable = false;
    };
    services = {
      containerization.enable = false;
      containers = {
        snowflake.enable = false;
      };
      pods = {
        languagetool.enable = false;
        penpot.enable = false;
        scrutiny.enable = false;
        vaultwarden.enable = false;
      };
      gitea.enable = false;
      jellyfin.enable	= false;
      kdeconnect.enable = false;
      k8s.enable = false;
      nginx.enable = false;
      vpn.enable = false;
      ssh.enable = false;
      syncthing.enable = false;
      transmission.enable = false;
    };
    theme.active = "quack-hidpi";
  };

  ## Local config
  programs.ssh.startAgent = false;
  services.openssh.startWhenNeeded = false;
  networking.networkmanager.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false
  # here. Per-interface useDHCP will be mandatory in the future, so this
  # generated config replicates the default behaviour.
  networking.useDHCP = false;

  # Set eurkey as default layout
  # Optionally set more keymaps and use them with bin/keymapswitcher
  services.xserver.layout = "fr";

  # Set default monitor
  environment.variables = rec {
    MAIN_MONITOR = "Virtual-1";
  };

  programs.dconf.enable = true;

  # Scale all elemnts
  services.xserver.dpi = 350;
  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    QT_SCALE_FACTOR = "2";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };

  # Auto-login user ziedak
  services.xserver.displayManager.lightdm.greeters.mini.extraConfig = ''
    [SeatDefaults]
    autologin-user=ziedak
  '';

  # Do not start a sulogin shell if mounting a filesystem fails
  systemd.enableEmergencyMode = false;
}
