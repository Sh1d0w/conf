{ config, lib, pkgs, ... }:

{
  home.file."${config.xdg.configHome}/wallpaper.png".source = ./flatppuccin_4k_macchiato.png;

  # Define a script to set wallpaper using osascript (AppleScript)
  home.file."${config.xdg.configHome}/set-wallpaper.sh".text = ''
    #!/usr/bin/env bash
    # Path to your wallpaper
    WALLPAPER_PATH="${config.xdg.configHome}/wallpaper.png"

    # Use AppleScript to set the wallpaper for all displays
    osascript -e "tell application \"System Events\" to set picture of every desktop to \"$WALLPAPER_PATH\""
  '';

  # Make the script executable
  home.activation.setWallpaper = lib.mkAfter ''
    chmod +x ${config.xdg.configHome}/set-wallpaper.sh
  '';

  # Optionally, run the script when the system starts
  systemd.user.services.setWallpaper = {
    description = "Set wallpaper using osascript";
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart = "${config.xdg.configHome}/set-wallpaper.sh";
  };
}