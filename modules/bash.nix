{config, pkgs, ...}:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;

    initExtra = ''
      fastfetch
      if [ -f $HOME/.bashrc-personal ]; then
        source $HOME/.bashrc-personal
      fi
    '';

    shellAliases = {
      # Enhanced NH aliases...
      nos = "nh os switch . --dry";                               # Safe preview of system changes
      ngc = "nh clean all --keep-since 7d --keep 10";             # Clean both user and system
      ngcd = "nh clean all --dry --keep-since 7d --keep 10";      # Clean both user and system

      # ls aliases...
      ll = "eza -l --icons=always --group-directories-first --git --color=always";
      la = "eza -la --icons=always --group-directories-first --git --color=always";
      ls = "eza --icons=always --group-directories-first --color=always";
      lt = "eza --tree --icons=always --group-directories-first --color=always";

      # cat alias...
      cat = "bat --paging=always --color=always"; # Use 'bat' as a more feature-rich replacement for 'cat'

      # Vscode alias...
      vcr = "code -r";
      #   less ephemeral
      ".." = "cd ..";
      ",," = "nix run nixpkgs#";
      ",s" = "nix shell nixpkgs#";

      v = "nvim"; # Open nvim
      sv = "sudo nvim"; # Open nvim with sudo
    };
  };
}