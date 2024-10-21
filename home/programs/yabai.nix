{ config, lib, pkgs, ... }:

with lib;

let
  yabaiConfigFile = "${config.home.homeDirectory}/.config/yabai/yabairc";
  launchAgentPath = "${config.home.homeDirectory}/Library/LaunchAgents/com.koekeishiya.yabai.plist";
in
{
  options.services.yabai = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the yabai window manager.";
    };
  };

  config = mkMerge [
    (mkIf config.services.yabai.enable {
      home.packages = [ pkgs.yabai ];

      home.activation.installYabaiService = lib.hm.dag.entryAfter ["writeBoundary"] ''
        mkdir -p ~/Library/LaunchAgents
        cat > ${launchAgentPath} <<EOF
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
          <dict>
            <key>Label</key>
            <string>com.koekeishiya.yabai</string>
            <key>ProgramArguments</key>
            <array>
              <string>${pkgs.yabai}/bin/yabai</string>
              <string>-c</string>
              <string>${yabaiConfigFile}</string>
            </array>
            <key>RunAtLoad</key>
            <true/>
            <key>KeepAlive</key>
            <true/>
            <key>StandardErrorPath</key>
            <string>/tmp/yabai.err</string>
            <key>StandardOutPath</key>
            <string>/tmp/yabai.out</string>
            <key>EnvironmentVariables</key>
            <dict>
              <key>PATH</key>
              <string>${pkgs.yabai}/bin:${pkgs.stdenv.shell}/bin:/usr/local/bin:/usr/bin:/bin</string>
            </dict>
          </dict>
        </plist>
        EOF
      '';
    })

    (mkIf (!config.services.yabai.enable) {
      home.activation.removeYabaiService = lib.hm.dag.entryAfter ["writeBoundary"] ''
        if [ -f ${launchAgentPath} ]; then
          rm -f ${launchAgentPath}
        fi
      '';
    })
  ];
}

