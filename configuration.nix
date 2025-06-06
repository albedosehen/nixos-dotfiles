# NixOS-WSL config: system packages and settings
{
  pkgs,
  user,
  host,
  inputs,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  wsl = {
    enable = true;
    defaultUser = user;
    docker-desktop.enable = true;
    useWindowsDriver = true;
    wrapBinSh = true;

    interop = {
      includePath = true;
      register = true;
    };

    usbip = {
      enable = false;
      autoAttach = [ ]; # busid's for auto device attachment
      # Obtain the Windows host where Usbipd process is running.
      snippetIpAddress = "$(ip route list | sed -nE 's/(default)? via (.*) dev eth0 .*/\\2/p' | head -n1)";
    };

    wslConf = {
      boot = {
        systemd = true;
        command = "${pkgs.zsh}/bin/zsh";
      };
      interop = {
        enabled = true;
        appendWindowsPath = true;
      };
      user = {
        default = user;
      };
      network = {
        hostname = host;
        generateHosts = true;
        #generateResolveConf = true;
      };
    };
    startMenuLaunchers = true;
    # tarball.configPath = "~/nixos/nixos-wsl.tarball.gz";
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  programs.ssh.startAgent = false;

  environment.variables = {
    LD_LIBRARY_PATH = "/usr/lib/wsl/lib:$LD_LIBRARY_PATH";
    SSH_AUTH_SOCK = "/mnt/wsl/ssh-agent.sock";
  };

  # Keep only system-wide packages here
  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    nvtopPackages.full # NVIDIA GPU monitoring tool
    socat # Multipurpose relay tool (Needed for SSH agent proxy)
    zsh
    starship
    nvd # Nix version daemon
    wslu # WSL utilities
    coreutils
  ];

  services = {
    openssh.enable = true;
  };

  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs;
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      trusted-users = [
        "root"
        user
      ];
      max-jobs = "auto";
      cores = 0;
      keep-outputs = true;
      keep-derivations = true;
      fallback = true;
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://cuda-maintainers.cachix.org"
        "https://devenv.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];
      sandbox = true;
      use-xdg-base-directories = true;
      download-attempts = 3;
      connect-timeout = 5;
      min-free = 128000000;
      max-free = 1000000000;
    };

    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
      default.flake = inputs.nixpkgs;
    };
  };

  system.stateVersion = "25.05";

  systemd.user.services.ssh-agent-proxy = {
    description = "Windows SSH agent proxy";
    path = [
      pkgs.wslu
      pkgs.coreutils
      pkgs.bash
    ];
    serviceConfig = {
      ExecStartPre = [
        "${pkgs.coreutils}/bin/mkdir -p /mnt/wsl"
        "${pkgs.coreutils}/bin/rm -f /mnt/wsl/ssh-agent.sock"
      ];
      ExecStart = "${pkgs.writeShellScript "ssh-agent-proxy" ''
        set -x  # Enable debug output

        WIN_USER="$("${pkgs.wslu}/bin/wslvar" USERNAME 2>/dev/null || echo $USER)"
        NPIPE_PATHS=(
          "/mnt/c/Users/$WIN_USER/AppData/Local/Microsoft/WinGet/Links/npiperelay.exe"
          "/mnt/c/ProgramData/chocolatey/bin/npiperelay.exe"
        )

        NPIPE_PATH=""
        for path in "''${NPIPE_PATHS[@]}"; do
          echo "Checking npiperelay at: $path"
          if [ -f "$path" ]; then
            NPIPE_PATH="$path"
            break
          fi
        done

        if [ -z "$NPIPE_PATH" ]; then
          echo "npiperelay.exe not found in expected locations!"
          exit 1
        fi

        echo "Using npiperelay from: $NPIPE_PATH"

        exec ${pkgs.socat}/bin/socat -d UNIX-LISTEN:/mnt/wsl/ssh-agent.sock,fork,mode=600 \
          EXEC:"$NPIPE_PATH -ei -s //./pipe/openssh-ssh-agent",nofork
      ''}";
      Type = "simple";
      Restart = "always";
      RestartSec = "5";
      StandardOutput = "journal";
      StandardError = "journal";
    };
    wantedBy = [ "default.target" ];
  };

  systemd.user.services.ssh-agent-proxy.serviceConfig.RuntimeDirectory = "ssh-agent";

  programs.command-not-found.enable = false;

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 6d --keep 5";
    };
    flake = "/home/${user}/nixos-config";
  };

  users.users.${user} = {
    shell = pkgs.zsh;
    isNormalUser = true;
  };
}
