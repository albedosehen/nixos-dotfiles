{ ... }:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;

    initExtra = ''
      if [ -f $HOME/.bashrc-personal ]; then
        source $HOME/.bashrc-personal
      fi
      export DIRENV_LOG_LEVEL=error;

      # Nix garbage collection and update helper
      nix-cleanup() {
          nix-collect-garbage -d
          nix store optimise
          sudo nix-collect-garbage -d
          sudo nix store optimise
      }

      # Quick flake update
      nix-update() {
          nix flake update
          sudo nixos-rebuild switch --flake .#nixos
      }

      # Initialize nix-index database if it doesn't exist
      # NOTE: Use nix-index-database instead of nix-index
      #if [ ! -f ~/.cache/nix-index/files ]; then
      #    echo "Initializing nix-index database..."
      #    nix-index
      #fi

      # Define ,, and ,s as functions for better argument handling
      function ,,() {
          nix run "nixpkgs#$1" -- "''${@:2}"
      }

      function ,s() {
          nix shell "nixpkgs#$1" -- "''${@:2}"
      }
    '';

    shellAliases = {
      # Enhanced NH aliases...
      nos = "nh os switch .";
      nosd = "nh os switch . --dry";
      noh = "nh home switch .";
      nohd = "nh home switch . --dry";
      ngc = "nh clean all --keep-since 7d --keep 10"; # Clean both user and system
      ngcd = "nh clean all --dry --keep-since 7d --keep 10"; # Clean both user and system

      # ls aliases...
      ll = "eza -l --icons=always --group-directories-first --git --color=always";
      la = "eza -la --icons=always --group-directories-first --git --color=always";
      ls = "eza --icons=always --group-directories-first --color=always";
      lt = "eza --tree --icons=always --group-directories-first --color=always";

      # cat alias...
      cat = "bat --paging=always --color=always"; # Use 'bat' as a more feature-rich replacement for 'cat'

      # Vscode alias...
      vcr = "code -r";
      vsc = "code";

      ".." = "cd ..";

      v = "nvim"; # Open nvim
      sv = "sudo nvim"; # Open nvim with sudo
      z = "zoxide";
    };
  };
}
