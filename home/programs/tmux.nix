{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.tmux = {
    enable = true;

    aggressiveResize = true;
    baseIndex = 0;
    clock24 = true;
    customPaneNavigationAndResize = true;
    disableConfirmationPrompt = false;
    escapeTime = 0;
    historyLimit = 10000;
    keyMode = "vi";
    mouse = true;
    newSession = true;
    reverseSplit = true;
    secureSocket = false;
    sensibleOnTop = true;
    shortcut = "a";
    # For truecolor and styilzed fonts, set terminal to tmux.
    # It seems once pkgs.ncurses is installed there's an appropriate tmux
    # terminfo entry.
    terminal = lib.mkDefault "tmux";
    tmuxp.enable = true;
    tmuxinator.enable = true;

    plugins = [
      # pkgs.tmuxPlugins.battery
      # pkgs.tmuxPlugins.cpu
      pkgs.tmuxPlugins.yank
      # {
      #   plugin = pkgs.tmuxPlugins.resurrect;
      #   extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      # }
    ];

    extraConfig = ''
      set -g prefix ^A
      bind -T copy-mode-vi 'v' send -X begin-selection
      bind -T copy-mode-vi 'y' send -X copy-pipe-and-cancel !
      bind -T copy-mode-vi 'z' send -X rectangle-toggle
      bind -T copy-mode-vi Escape send -X cancel
      bind -T copy-mode-vi 'x' send -X cancel

      # ---------------------------------
      # colors
      # ---------------------------------
      # Allow truecolors.
      set -g default-terminal "tmux-256color"
      set -sag terminal-features ",*:RGB"
      set -sag terminal-features ",*:usstyle"

      setw -g renumber-windows on
      setw -g allow-rename off
      setw -g status on
      setw -g clock-mode-colour 'default'

      # List of plugins
      set -g @plugin 'tmux-plugins/tpm'
      set -g @plugin 'tmux-plugins/tmux-sensible'
      set -g @plugin 'catppuccin/tmux'
      set -g @plugin 'tmux-plugins/tmux-yank'
      set -g @plugin 'fcsonline/tmux-thumbs'
      set -g @plugin 'sainnhe/tmux-fzf'

      # Configure the catppuccin plugin
      set -g @catppuccin_flavor "mocha"
      set -g @catppuccin_window_status_style "rounded"
      set -g @catppuccin_window_number_position "right"

      set -g @catppuccin_window_default_fill "number"
      set -g @catppuccin_window_default_text "#W "

      set -g @catppuccin_window_current_fill "number"
      set -g @catppuccin_window_current_text "#W "

      set -g @catppuccin_status_left_separator  " "
      set -g @catppuccin_status_right_separator ""
      set -g @catppuccin_status_fill "icon"
      set -g @catppuccin_status_connect_separator "no"

      set -g @catppuccin_directory_text "#{pane_current_path}"

      set -g status-left ""
      set -g  status-right "#{E:@catppuccin_status_directory}"
      set -ag status-right "#{E:@catppuccin_status_date_time}"

      # Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
      run '~/.config/tmux/plugins/tpm/tpm'
    '';
  };
}
