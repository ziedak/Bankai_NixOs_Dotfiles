{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.zsh;
in {
  options.modules.shell.zsh = with types; {
    enable = mkBoolOpt false;

    aliases = mkOpt (attrsOf (either str path)) {};

    rcInit = mkOpt' lines "" ''
      Zsh lines to be written to $XDG_CONFIG_HOME/zsh/extra.zshrc and sourced by
      $XDG_CONFIG_HOME/zsh/.zshrc
    '';
    envInit = mkOpt' lines "" ''
      Zsh lines to be written to $XDG_CONFIG_HOME/zsh/extra.zshenv and sourced
      by $XDG_CONFIG_HOME/zsh/.zshenv
    '';

    rcFiles  = mkOpt (listOf (either str path)) [];
    envFiles = mkOpt (listOf (either str path)) [];
  };

  config = mkIf cfg.enable {
    users.defaultUserShell = pkgs.zsh;

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      # I init completion myself, because enableGlobalCompInit initializes it
      # too soon, which means commands initialized later in my config won't get
      # completion, and running compinit twice is slow.
      enableGlobalCompInit = false;
      promptInit = "";
    };

    user.packages = with pkgs; [
      zsh
      # ZSH completions for Nix, NixOS, and NixOps
      nix-zsh-completions
      # Fish shell history-substring-search for Zsh
      zsh-history-substring-search
      # cat(1) clone with syntax highlighting and Git integration
      bat
      # Replacement for 'ls' written in Rust
      exa
      # Quick command-line access to files and directories for POSIX shells
      fasd
      # Intuitive sed alternative
      sd
      # Intuitive find alternative
      fd
      # Command-line fuzzy finder written in Go
      fzf
      # Set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)
      psmisc
      # Simplified and community-driven man pages
      tldr
    ];

    env = {
      ZDOTDIR     = "$XDG_CONFIG_HOME/zsh";
      ZSH_CACHE   = "$XDG_CACHE_HOME/zsh";
      ZGEN_DIR    = "$XDG_DATA_HOME/zsh";
      ZGEN_SOURCE = "$ZGEN_DIR/zgen.zsh";
      FZF_DEFAULT_OPTS = "--reverse --ansi --inline-info --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4";
    };

    home.configFile = {
      # Write it recursively so other modules can write files to it
      "zsh" = { source = "${configDir}/zsh"; recursive = true; };

      # Why am I creating extra.zsh{rc,env} when I could be using extraInit?
      # Because extraInit generates those files in /etc/profile, and mine just
      # write the files to ~/.config/zsh; where it's easier to edit and tweak
      # them in case of issues or when experimenting.
      "zsh/extra.zshrc".text =
        let aliasLines = mapAttrsToList (n: v: "alias ${n}=\"${v}\"") cfg.aliases;
        in ''
           # This file was autogenerated, do not edit it!
           ${concatStringsSep "\n" aliasLines}
           ${concatMapStrings (path: "source '${path}'\n") cfg.rcFiles}
           ${cfg.rcInit}
        '';

      "zsh/extra.zshenv".text = ''
        # This file is autogenerated, do not edit it!
        ${concatMapStrings (path: "source '${path}'\n") cfg.envFiles}
        ${cfg.envInit}
      '';
    };

    system.userActivationScripts.cleanupZgen = "rm -fv $XDG_CACHE_HOME/zsh/*";
  };
}
