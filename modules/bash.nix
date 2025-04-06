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

      # cat alias...
      cat = "bat --paging=always --color=always";

      ".." = "cd ..";
      ",," = ",,";
      ",s" = ",s";

      v = "nvim";
      z = "zoxide";

    };
  };
}
