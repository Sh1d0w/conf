{
  config,
  nixpkgs,
  pkgs,
  user,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "Sh1d0w";
    userEmail = "5074917+Sh1d0w@users.noreply.github.com";
    lfs.enable = true;

    aliases = {
      df = "diff --color-words=. --ws-error-highlight=new,old";
      lg = "log --decorate";
      lga = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
      ls = "ls-files";
      new = "switch -c";
      root = "rev-parse --show-toplevel";
      st = "status";
      sv = "status --verbose";
      sw = "switch";
      unstage = "restore --staged";
      home = "!git --git-dir=\"\${HOME}/.git/\" --work-tree=\"\${HOME}\"";
    };

    extraConfig = {
      # branch.autosetuprebase = "always";
      color = {
        diff = "auto";
        status = "auto";
        branch = "auto";
        interactive = "auto";
        ui = true;
        pager = true;
      };
      # core.askPass = ""; # needs to be empty to use terminal for ask pass
      credential.helper = "cache --timeout 604800";
      init = {
        defaultBranch = "main";
      };
      github = {
        user = "sh1d0w";
      };
      pull = {
        rebase = true;
        ff = true;
      };
      push = {
        default = "tracking";
        autoSetupRemote = true;
      };
      core = {
        editor = "nvim";
        pager = "delta";
        excludesFile = "${config.xdg.configHome}/git/gitignore";
      };
      interactive = {
        diffFilter = "delta --color-only";
      };
      merge = {
        conflictStyle = "diff3";
      };
      diff = {
        colorMoved = "default";
      };
    };
  };
}
