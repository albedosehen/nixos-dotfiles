
{config, pkgs, ...}: 
{
    programs.nixvim = {
    	enable = true;
	vimAlias = true;
	
	opts = {
	    scrolloff = 10;
	    number = true;
            relativenumber = true;
	    expandtab = true;
	    smartindent = true;
            softtabstop = 2;
            tabstop = 2;
            foldlevelstart = 99;
            cursorline = true;
            swapfile = false;
            backup = false;
            undofile = true;
            wrap = true;
            winhl = "NormalFloat:PMenu";
            scroll = 10;
            splitright = true;
	};
    };
}
