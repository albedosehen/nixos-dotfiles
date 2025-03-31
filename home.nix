{
  config,
  pkgs,
  user,
  nixvim,
  nix-index-database,
  system,
  ...
}:
let
  homeDir = "/home/${user}";
in
{
  home.username = user;
  home.homeDirectory = homeDir;
  home.stateVersion = "24.11";

  imports = [
    ./modules
    nix-index-database.hmModules.nix-index
  ];

  home.sessionVariables = {
    NODE_EXTRA_CA_CERTS = "/etc/ssl/certs/ca-bundle.crt";
  };

  # Packages that should be installed to the user profile
  home.packages = with pkgs; [
    # Dev tools
    vim # Text editor
    wget # Network downloader
    curl # Command line tool for transferring data
    jq # JSON processor
    yq # YAML processor
    httpie # HTTP client
    delta # Git diff viewer
    lazygit # Terminal-based git UI
    alejandra # Nix formatter
    home-manager # NixOS user configuration manager
    nil # Nix LSP (Language Server Protocol)
    just # Command runner (like make but simpler)
    difftastic # Better diff tool
    shellcheck # Shell script analyzer
    nodePackages.prettier # Code formatter
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "JetBrainsMono"
        "NerdFontsSymbolsOnly"
        "Noto"
      ];
    }) # Nerd Fonts

    # System tools
    btop # System monitoring
    ripgrep # Search tool (like grep but faster)
    fd # Fast file search tool
    tree # Display directory structure
    duf # Disk usage visualizer
    ncdu # Disk usage analyzer
    bottom # Terminal system monitor
    du-dust # Disk usage tool
    procs # Process viewer
    sd # Text replacement tool
    choose # Select options from list
    cacert

    # Shell tools
    fzf # Fuzzy finder
    bat # Cat with syntax highlighting
    zoxide # Smart directory navigator

    # Utils
    tldr # Simplified man pages
    neofetch # System information tool
    p7zip # Compression tool
    unzip # Zip archive extractor
    zip # Zip archive compressor

    # Python development tools
    uv # Python async web server
    ruff # Python linter
    nh # Python script runner
    vivid # Python color output

    # Nix-specific tools
    #comma # Run programs without installing them
    nix-output-monitor # Better nix-build output
    nixpkgs-review # Review nixpkgs pull requests
    statix # Lint and suggest improvements for Nix code

    # Optional but recommended
    devenv # Development environments
    direnv # Per-directory environment variables

    # Add nixvim
    nixvim.packages.${system}.default
  ];

  # Git configuration
  programs.git = {
    enable = true;
    userName = "albedosehen"; # FIXME: [git::username] Personalize to your identity
    userEmail = "shonpt@outlook.com"; # FIXME: [git::email] Personalize to your identity
    delta.enable = true;
    lfs.enable = true;

    includes = [
      {
        condition = "gitdir:${homeDir}/paradigm/"; # FIXME: [git::work.directory] Personalize to your identity
        contents = {
          user.name = "Shon Thomas"; # FIXME: [git::work.username] Personalize to your identity
          user.email = "shon.thomas@myparadigm.com"; # FIXME: [git::work.email] Personalize to your identity
        };
      }
    ];

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      push.autoSetupRemote = true;
      core.autocrlf = "input"; # For WSL
      diff.colorMoved = "default";
      merge.conflictStyle = "diff3";
      rebase.autoStash = false;
      credential.helper = "/mnt/c/Program\\ Files/Git/mingw64/libexec/git-core/git-credential-wincred.exe"; # For WSL
    };

    aliases = {
      st = "status";
      co = "checkout";
      sw = "switch";
      br = "branch";
      ci = "commit";
      pu = "push";
      pl = "pull";
      fe = "fetch --all";
      fep = "fetch --all --prune --tags"; # Fetch all branches and tags
      fepu = "fetch --all --prune --tags --update-shallow"; # Fetch all branches, tags, and update shallow clones
      lg = "log --oneline --graph --decorate --all";
      lga = "log --oneline --graph --decorate --all --abbrev-commit --color-words";
      lga1 = "log --oneline --graph --decorate --all --abbrev-commit --color-words --max-count=1";
      lga3 = "log --oneline --graph --decorate --all --abbrev-commit --color-words --max-count=3";
      lga5 = "log --oneline --graph --decorate --all --abbrev-commit --color-words --max-count=5";
      lga10 = "log --oneline --graph --decorate --all --abbrev-commit --color-words --max-count=10";

      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      viz = "!gitk";
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      version = 1;
      git_protocol = "https";
      editor = "nvim";
      prompt = "enabled";
      prefer_editor_prompt = "disabled";
      pager = "less";
      # aliases = {
      #
      # };
    };
  };

  programs.lazygit = {
    enable = true;
    settings.gui = {
      showFileTree = false;
      nerdFontsVersion = "3";
      theme.selectedLineBgColor = [ "reverse" ];
    };
  };

  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
  };

  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.nix-index-database.comma.enable = true;

  xdg = {
    enable = true;
    configHome = "${config.home.homeDirectory}/.config";
    cacheHome = "${config.home.homeDirectory}/.cache";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";
  };
}
