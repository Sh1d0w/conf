{
  config,
  pkgs,
  ...
}: {
  programs.node = {
    enable = true;

    npm.enable = true;

    # stable version
    package = pkgs.nodejs-20_x;
  };
}
