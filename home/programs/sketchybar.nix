{ config, lib, pkgs, ... }:

with lib;

let
  sketchybarConfigFile = "${config.home.homeDirectory}/.config/sketchybar/sketchybarrc";
  launchAgentPath = "${config.home.homeDirectory}/Library/LaunchAgents/com.felixkratz.sketchybar.plist";
in
{
  options.services.sketchybar = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the Sketchybar status bar.";
    };
  };

  config = mkMerge [
    (mkIf config.services.sketchybar.enable {
      home.packages = [
        pkgs.sketchybar
        pkgs.sketchybar-app-font
      ];

      home.activation.installSketchybarService = lib.hm.dag.entryAfter ["writeBoundary"] ''
        mkdir -p ~/Library/LaunchAgents
        cat > ${launchAgentPath} <<EOF
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
          <dict>
            <key>Label</key>
            <string>com.felixkratz.sketchybar</string>
            <key>ProgramArguments</key>
            <array>
              <string>${pkgs.sketchybar}/bin/sketchybar</string>
            </array>
            <key>RunAtLoad</key>
            <true/>
            <key>KeepAlive</key>
            <true/>
            <key>StandardErrorPath</key>
            <string>/tmp/sketchybar.err</string>
            <key>StandardOutPath</key>
            <string>/tmp/sketchybar.out</string>
            <key>EnvironmentVariables</key>
            <dict>
              <key>PATH</key>
              <string>${pkgs.sketchybar}/bin:${pkgs.stdenv.shell}/bin:/usr/local/bin:/usr/bin:/bin</string>
            </dict>
          </dict>
        </plist>
        EOF
      '';
    })

    (mkIf (!config.services.sketchybar.enable) {
      home.activation.removeSketchybarService = lib.hm.dag.entryAfter ["writeBoundary"] ''
        if [ -f ${launchAgentPath} ]; then
          rm -f ${launchAgentPath}
        fi
      '';
    })
  ];
}

