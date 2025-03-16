
{config, pkgs, ...}: 
{
    programs.starship = {
        enable = true;
        enableZshIntegration = true;
        settings = {
            # Use Catppuccin theme (Macchiato variant)
            palette = "catppuccin_macchiato";

            # Theme color definitions
            palettes.catppuccin_macchiato = {
                rosewater = "#f4dbd6";
                flamingo = "#f0c6c6";
                pink = "#f5bde6";
                mauve = "#c6a0f6";
                red = "#f28c8e";
                maroon = "#eba0ac";
                peach = "#f7b2a2";
                yellow = "#e8e3a1";
                green = "#a6e3a1";
                teal = "#7fdbca";
                sky = "#99d1db";
                sapphire = "#74c7ec";
                blue = "#8caaee";
                lavender = "#b5bfe2";
                text = "#cad3f5";
                subtext1 = "#b5bfe2";
                subtext0 = "#a6accd";
                overlay2 = "#939bb2";
                overlay1 = "#7f849c";
                overlay0 = "#6c7086";
                surface2 = "#585b70";
                surface1 = "#45475a";
                surface0 = "#313244";
                base = "#1e1e2e";
                mantle = "#181825";
                crust = "#11111b";
            };


            # Modern symbol styling
            character = {
                success_symbol = "[➜](bold green)";
                error_symbol = "[✗](bold red)";
            };

            # Disable some modules that might slow down the prompt
            aws.disabled = true;
            gcloud.disabled = true;
            kubernetes.disabled = true;

            # Directory configuration
            directory = {
                truncation_length = 5;
                truncate_to_repo = true;
            };

            # Git configuration
            git_branch = {
                symbol = "🌱 ";
                truncation_length = 20;
                truncation_symbol = "...";
            };

            git_status = {
                conflicted = "⚔️";
                ahead = "🚀";
                behind = "🐌";
                diverged = "🔀";
                up_to_date = "✅";
                untracked = "🌊";
                stashed = "📦";
                modified = "📝";
                staged = "[++\\($count\\)](green)";
                renamed = "🔄";
                deleted = "🗑️";
            };

            # Nix shell configuration
            nix_shell = {
                symbol = "❄️ ";
                format = "via [$symbol$state( \($name\))]($style) ";
            };
        };
    };
}