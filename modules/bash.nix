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

      # Docker Compose Helpers
      du() {
        docker compose up "$@"
      }

      dub() {
        docker compose up "$@" -d --build
      }

      dup() {
        profile=$1
        shift
        docker compose --profile "$profile" up "$@"
      }

      dubp() {
        profile=$1
        shift
        docker compose --profile "$profile" up -d --build "$@"
      }

      # Docker Compose Down
      dd() {
        docker compose down "$@"
      }

      ddp() {
        profile=$1
        shift
        docker compose --profile "$profile" down --rmi all "$@"
      }

      # Docker Compose Down (Removes Orphan Containers not defined in the current compose file but leaves the defined services running)
      ddo() {
        docker compose down --remove-orphans
      }

      # Docker Compose Down & Remove Images (Pulled & Built) & Removes Named and Anonymous Volumes & Removes Orphan Containers not defined in the current compose file.
      ddiv() {
        docker compose down "$@" --rmi all --volumes
      }

      ddivp() {
        profile=$1
        shift
        docker compose --profile "$profile" down --rmi all --volumes "$@"
      }

      # Docker Compose Restart
      dr() {
        docker compose restart "$@"
      }

      drp() {
        profile=$1
        shift
        docker compose --profile "$profile" restart "$@"
      }

      # Docker Compose Stop
      dsp() {
        docker compose stop "$@"
      }

      dspp() {
        profile=$1
        shift
        docker compose --profile "$profile" stop "$@"
      }

      # Docker Compose Logs
      dl() {
        docker compose logs -f "$@"
      }

      # Docker Compose Exec
      de() {
        service=$1
        shift
        docker compose exec "$service" "$@"
      }

      # Docker Compose Build
      db() {
        docker compose build "$@"
      }

      # Docker PS formatted
      dls() {
        docker ps --format '{{.Names}}\t{{.Status}}\t{{.Ports}}'
      }

      # Docker Clean System
      dprune() {
        docker system prune -af "$@"
      }

      ddestroy() {
       # Removes everything. Containers, images, volumes, networks, caches, etc. Ignores tags.
        # WARNING: This is a destructive command. Use with caution.
        docker system prune -a --volumes
      }

      # Port Inspection
      port() {
        sudo lsof -i -P -n | grep LISTEN | grep "$1"
      }

      portf() {
        sudo lsof -i -P -n | grep LISTEN | fzf
      }

      # Inspect or kill a port
      portp() {
        sudo lsof -i :$1
      }

      killport() {
        sudo fuser -k $1/tcp
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
