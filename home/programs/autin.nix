{
  config,
  pkgs,
  ...
}: {
  programs.autin = {
    enable = true;

    enableZshIntegration = true;

    settings = {
      style = "full";
    };
  };
}
