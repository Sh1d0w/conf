{
  config,
  pkgs,
  ...
}: {
  programs.nodejs = {
    enable = true;

    npm.enable = true;
  };
}
