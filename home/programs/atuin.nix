{
  config,
  pkgs,
  ...
}: {
  programs.atuin = {
    enable = true;

    enableZshIntegration = true;

    settings = {
      style = "full";
    };
  };
}
