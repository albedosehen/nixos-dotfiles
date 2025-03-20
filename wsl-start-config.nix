# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, pkgs, ... }:
let
  user = "nixos"; # FIXME: Update to your username
in
{
  imports = [
    # include NixOS-WSL modules
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
        command = "echo 'Oh wow! NixOS on WSL!'";
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
    vim # NixOS comes with nano
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
