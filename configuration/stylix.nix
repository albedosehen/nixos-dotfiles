{
  pkgs,
  ...
}: {
  stylix = {
    enable = true;

    # Optional: Set wallpaper if you want a full theme setup
    image = "";

    base16Scheme = {
      base00 = "24273a"; # Background
      base01 = "1e2030"; # Lighter Background
      base02 = "363a4f"; # Selection Background
      base03 = "494d64"; # Comments
      base04 = "cad3f5"; # Light Foreground
      base05 = "cad3f5"; # Foreground
      base06 = "f4dbd6"; # Lighter Foreground
      base07 = "f0c6c6"; # Lightest Foreground
      base08 = "ed8796"; # Red
      base09 = "f5a97f"; # Orange
      base0A = "eed49f"; # Yellow
      base0B = "a6da95"; # Green
      base0C = "8bd5ca"; # Cyan
      base0D = "7dc4e4"; # Blue
      base0E = "c6a0f6"; # Purple
      base0F = "f4dbd6"; # Pink
    };

    polarity = "dark";
    opacity.terminal = 0.8; # Semi-transparent terminals

    # Cursor Theme
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    # Font Configurations
    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 12;
      };
    };
  };
}
