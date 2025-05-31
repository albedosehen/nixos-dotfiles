# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, pkgs, ... }:
let
  user = "nixos"; # Optional: Update to your preferred username
in
{
  imports = [
    <nixos-wsl/modules>
  ];

  wsl = {
    enable = true;
    defaultUser = "${user}";
    docker-desktop.enable = true;
    interop = {
      includePath = true; # Adds Windows $PATH
      register = false;
    };

    # Enable USB over IP e.g access the host peripherals from within WSL
    usbip = {
      enable = false;
      autoAttach = [ ]; # busid's for auto device attachment
      # Obtain the Windows host where Usbipd process is running.
      snippetIpAddress = "$(ip route list | sed -nE 's/(default)? via (.*) dev eth0 .*/\\2/p' | head -n1)";
    };
    useWindowsDriver = false; # Enable OpenGL support
    wrapBinSh = true; # Sets the correct env vars when using WSL2 systemd
    wslConf = {
      boot = {
        systemd = true;
        command = "echo 'NixOS 25.05'";
      };
      interop = {
        enabled = true;
        appendWindowsPath = false; # Prevent WSL Windows $PATH pollution
      };
      user = {
        default = "${user}";
      };
      network = {
        hostname = config.networking.hostName;
        generateHosts = true;
        generateResolvConf = true;
      };
    };
    startMenuLaunchers = false;
    # tarball.configPath = "~/nixos-wsl/nixos-wsl.tarball.gz";
  };

  environment.systemPackages = with pkgs; [
    git # Version control system
    curl # Command-line tool for transferring data
    wget # Network downloader
    zsh # Z shell
    starship # Minimalist shell prompt
    nvd # Nix version daemon
    wslu # WSL utilities
    coreutils # Basic file, shell, and text manipulation
  ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      trusted-users = [
        "root"
        "${user}"
      ];
    };
  };

  system.stateVersion = "25.05";
}
