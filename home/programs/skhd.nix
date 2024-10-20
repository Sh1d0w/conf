{ config, lib, pkgs, ... }:

with lib;

let
  skhdConfigFile = "${config.home.homeDirectory}/.config/skhd/skhdrc";
  launchAgentPath = "${config.home.homeDirectory}/Library/LaunchAgents/com.user.skhd.plist";
in
{
  # Option to enable or disable skhd service
  options.services.skhd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the skhd hotkey daemon.";
    };
    
    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra configuration for skhd to be added to skhdrc.";
    };
  };

  # Merged configuration for enabling and disabling the service
  config = mkMerge [
    (mkIf config.services.skhd.enable {
      # Install skhd package
      home.packages = [ pkgs.skhd ];

      # Create skhdrc file with user's configuration
      home.file = {
        "${skhdConfigFile}".text = ''
          # Default skhd config
          # You can place custom configuration here
          cmd - return : open -a Terminal

          # Slack
          alt - s: open -a /Applications/Slack.app/Contents/MacOS/Slack

          # WezTerm
          alt - w: |
            if pgrep -x "WezTerm" > /dev/null; then
              open -a WezTerm
            else
              open -a /Applications/WezTerm.app/Contents/MacOS/WezTerm
            fi

          ${config.services.skhd.extraConfig}
        '';
      };

      # Create the launchd agent to start skhd on macOS
      home.activation.installSkhdService = lib.hm.dag.entryAfter ["writeBoundary"] ''
        mkdir -p ~/Library/LaunchAgents
        cat > ${launchAgentPath} <<EOF
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
          <dict>
            <key>Label</key>
            <string>com.user.skhd</string>
            <key>ProgramArguments</key>
            <array>
              <string>${pkgs.skhd}/bin/skhd</string>
              <string>-c</string>
              <string>${skhdConfigFile}</string>
            </array>
            <key>RunAtLoad</key>
            <true/>
            <key>KeepAlive</key>
            <true/>
            <key>StandardErrorPath</key>
            <string>/tmp/skhd.err</string>
            <key>StandardOutPath</key>
            <string>/tmp/skhd.out</string>
          </dict>
        </plist>
        EOF
      '';
    })

    # Cleanup logic when skhd is disabled
    (mkIf (!config.services.skhd.enable) {
      home.activation.removeSkhdService = lib.hm.dag.entryAfter ["writeBoundary"] ''
        if [ -f ${launchAgentPath} ]; then
          rm -f ${launchAgentPath}
        fi
      '';
    })
  ];
}