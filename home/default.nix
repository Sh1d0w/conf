{
  pkgs,
  lib,
  config,
  target,
  ...
}: let
  homebrew_prefix = "/opt/homebrew";
  local_bin = "$HOME/.local/bin";
  tpm = import ./programs/tpm.nix {
    inherit (pkgs) stdenv fetchFromGitHub lib; # Pass the necessary arguments
  };
in {
  # Let home-manager manage itself.
  imports = [
    programs/readline.nix
    programs/git.nix
    programs/starship.nix
    programs/eza.nix # TODO: Might need newer hm version. eza not found.
    programs/zsh.nix
    programs/bash.nix
    programs/tmux.nix
    programs/atuin.nix
    programs/skhd.nix

    # Wallpapers
    ./wallpapers/default.nix
  ];

  home = {
    username = lib.mkDefault "${target.user.name}";
    homeDirectory = lib.mkDefault (
      if pkgs.stdenv.isDarwin
      then "/Users/${config.home.username}"
      else "/home/${config.home.username}"
    );
    stateVersion = lib.mkDefault "${target.home.stateVersion}";

    # The home.packages option allows you to install Nix packages into your
    # home environment.
    # When using home-manager in nixOS or nix-darwin there does not seem to be
    # a significant different between installing (user configured) packages and
    # system packages. Thus currently we opt to install most tools via
    # home-manager for an admin type user.
    # NOTE: do not add home-manager to home.packages or
    # system packages to avoid collisions.
    packages = with pkgs;
      [
        alejandra
        awscli2
        bash
        bat # cat clone
        cachix
        carapace # cross-shell completions
        ctags
        nodejs
        curl
        delta # diff
        direnv #
        # entr
        eza # maintained version of exa.
        fd
        gh # github cli client
        git
        htop
        jq
        lazygit
        miller
        ripgrep
        sd # simple sed
        starship
        tmux
        tpm
        yabai
        wget
        zoxide # like z
        zellij # terminal multiplexer
        zsh

        # # It is sometimes useful to fine-tune packages, for example, by applying
        # # overrides. You can do that directly here, just don't forget the
        # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
        # # fonts?
        (nerdfonts.override {
          fonts = [
            "JetBrainsMono"
          ];
        })

        # # You can also create simple shell scripts directly inside your
        # # configuration. For example, this adds a command 'my-hello' to your
        # # environment:
        # (pkgs.writeShellScriptBin "my-hello" ''
        #   echo "Hello, ${config.home.username}!"
        # '')
      ]
      # On macOS, a nix provided clang will fail to link many Apple SDK
      # components. This can cause build issues, e.g., when using cargo.
      # One approach is to export PATH=/usr/bin:$PATH when building when cargo
      ++ (
        if pkgs.stdenv.isDarwin
        # NOTE: We did encounter an issue with the QuickTime framework being
        # unavailable.
        # then (builtins.attrValues darwin.apple_sdk.frameworks)
        then with darwin.apple_sdk.frameworks; [IOKit]
        else []
      );

    # Home Manager can symlink config files. The primary way to manage
    # plain files is through 'home.file'.
    # The actual symlinks point to read-only files,
    # TODO: This makes tinkering a bit of a pain. Consider
    # managing non-hm configurations manually.
    file = {
      # ".config/" = {
      #   recursive = true;
      #   source = ./etc/config;
      # };
      ".local/bin" = {
        recursive = true;
        source = ./bin;
      };
      ".local/bin/switch".source = ../switch;
      ".config/tmux/plugins/tpm".source = "${tpm}/share/tmux/plugins/tpm";
    };

    # NOTE: The shell must be managed by home-manager for env vars and aliases
    # to be available.
    sessionVariables = {
      LANG = "en_US.UTF-8";
      CARGO_HOME = "${config.xdg.stateHome}/cargo";
      CLICOLOR = "1";
      DOOMDIR = "${config.xdg.configHome}/doom";
      EDITOR = "nvim";
      GOPATH = "${config.xdg.stateHome}/go";
      HOMEBREW_BOOTSNAP = 1;
      HOMEBREW_CELLAR = /opt/homebrew/Cellar;
      HOMEBREW_NO_ANALYTICS = 1;
      # HOMEBREW_NO_AUTO_UPDATE = 1;
      HOMEBREW_PREFIX = /opt/homebrew;
      HOMEBREW_REPOSITORY = /opt/homebrew;
      IPYTHONDIR = "${config.xdg.configHome}/ipython";
      LESS = "-Mr";
      LESSHISTFILE = "${config.xdg.stateHome}/less/history";
      LISTLINKS = 1;
      # LS_COLORS handled by dircolors module.
      # LS_COLORS = "ExGxBxDxCxEgEdxbxgxcxd";
      MANCOLOR = 1;
      MANPAGER = "nvim --clean +Man!";
      PAGER = "less";
      STACK_ROOT = "${config.xdg.stateHome}/stack";
      # home-manager handles plugins directly.
      # TMUX_PLUGIN_MANAGER_PATH = "${config.xdg.stateHome}/tmux/plugins/";
      VISUAL = "nvim";
      PATH = "${local_bin}:$PATH:${homebrew_prefix}/bin:${homebrew_prefix}/sbin:${config.xdg.stateHome}/cargo/bin:${config.xdg.stateHome}/go/bin";
    };

    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "..2" = "cd ../..";
      "...." = "cd ../../..";
      "..3" = "cd ../../..";
      "....." = "cd ../../../..";
      "..4" = "cd ../../../..";
      dev = "nix develop";
    };
  };

  # Defaults to simply enable without much configuration.
  # More detailed configurations live in ./programs
  programs = {
    awscli.enable = true;
    bottom.enable = true;
    carapace.enable = true;
    dircolors.enable = true;
    home-manager.enable = true;
    htop.enable = true;
    zoxide.enable = true;
  };

  services = {
    skhd = {
      enable = true;
    };
  };

  xdg.enable = true;
  fonts.fontconfig.enable = true;
}
