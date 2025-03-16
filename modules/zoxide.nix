{config, pkgs, ...}: 
{
    programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
        #enableFishIntegration = true;
        options = [
            "--cmd"
            "cd"
        ];
    };

    home.sessionVariables = {
        _ZO_FZF_OPTS = "--height 40% --layout=reverse";  # Optional: Enhances `zoxide` when used with fzf
    };

    home.shellAliases = {
        conf = "z ~/.config";
        nixos = "z /etc/nixos";
        store = "z /nix/store";
    };
}