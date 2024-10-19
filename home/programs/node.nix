{
  config,
  pkgs,
  ...
}: {
  programs.node = {
    enable = true;

    npm.enable = true;
  };
}
