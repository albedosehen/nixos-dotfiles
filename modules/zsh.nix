{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    history = {
      ignoreAllDups = true;
      ignoreSpace = true;
      share = true;
      size = 10000;
      save = 10000;
    };
    # Enable oh-my-zsh
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "fzf"
        "command-not-found"
        "colored-man-pages"
        "dirhistory"
        "per-directory-history"
        "direnv"
        "history"
      ];
      theme = "agnoster";
    };
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    initExtra = ''
      # Prefer flake-style user profile paths
      if [ -f "$HOME/.local/state/nix/profile/etc/profile.d/hm-session-vars.sh" ]; then
        . "$HOME/.local/state/nix/profile/etc/profile.d/hm-session-vars.sh"
      fi

      # Create oh-my-zsh cache directory with proper permissions
      export ZSH_CACHE_DIR="$HOME/.cache/oh-my-zsh"
      if [[ ! -d "$ZSH_CACHE_DIR" ]]; then
          mkdir -p "$ZSH_CACHE_DIR"
          chmod 755 "$ZSH_CACHE_DIR"
      fi

      if [[ ! -d "$ZSH_CACHE_DIR/completions" ]]; then
          mkdir -p "$ZSH_CACHE_DIR/completions"
          chmod 755 "$ZSH_CACHE_DIR/completions"
      fi

      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward
      bindkey '^[w' kill-region

      export COLORTERM="truecolor"
      export EZA_ICON_SPACING=2
      export EZA_ICON_TYPE="nerd"

      # Better integration with Nix
      # Sources the multi-user Nix installation from the default profile 
      # for setting NIX_PATH, NIX_SSL_CERT_FILE, and nix-managed binaries
      # NOTE: This may not work in WSL2 if Nix is in single-user mode
      #if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      #    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      #fi

      # Add SSH agent socket configuration
      export SSH_AUTH_SOCK="/mnt/wsl/ssh-agent.sock"

      # Ensure proper locale for UTF-8 support
      export LANG=en_US.UTF-8
      export LC_ALL=en_US.UTF-8

      # Make sure VSCode terminal uses correct font
      export TERMINAL_FONT="FiraCode Nerd Font Mono"

      # Suppress direnv spam
      export DIRENV_LOG_FORMAT="";
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
    plugins = [
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];
    shellAliases = {
      # Enhanced NH aliases...
      aliases = ''alias | rg -i "${"1:-."}"'';
      ngc = "nix-cleanup"; # Clean both user and system
      nup = "nix-update";
      noss = "nh os switch ."; # WSL: Open a new terminal and run wsl -t NixOS && wsl -d NixOS root exit
      nossd = "nh os switch . --dry";
      noh = "nh home switch .";
      nhsd = "nh home switch ~/nixos-config/. --dry";
      nhs = "nh home switch ~/nixos-config/. && echo \"Reloading shell...\" && source ~/.zshrc";

      # ls aliases...
      ll = "eza -l --icons=always --group-directories-first --git --color=always";
      la = "eza -la --icons=always --group-directories-first --git --color=always";
      ls = "eza --icons=always --group-directories-first --color=always";
      lt = "eza --tree --icons=always --group-directories-first --color=always";

      cat = "bat --paging=always --color=always";

      ".." = "cd ..";
      ",," = ",,";
      ",s" = ",s";

      v = "nvim";
      z = "zoxide";
    };
  };
}
