# Shared tmux configuration
{ config, lib, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    escapeTime = 0;
    terminal = "tmux-256color";
    keyMode = "vi";
    mouse = true;
    baseIndex = 1;
    historyLimit = 50000;
    customPaneNavigationAndResize = true;

    extraConfig = ''
      # True color support
      set -ag terminal-overrides ",xterm-256color:RGB"

      # Vi copy-mode bindings
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi y send -X copy-selection-and-cancel

      # Intuitive splits (open in current directory)
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # New windows in current directory
      bind c new-window -c "#{pane_current_path}"

      # Reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded"
    '';
  };
}
