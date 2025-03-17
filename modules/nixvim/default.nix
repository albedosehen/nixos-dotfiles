{ pkgs, ... }:
{
  environment.variables.EDITOR = "nvim";
  environment.systemPackages = with pkgs; [ prettierd ];
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    colorschemes.ayu.enable = true;

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

    autoGroups = {
      highlight-yank = {
        clear = true;
      };
    };

    autoCmd = [
      {
        event = [ "TextYankPost" ];
        desc = "Highlight when yanking text";
        group = "highlight-yank";
        callback.__raw = "function() vim.highlight.on_yank() end";
      }
    ];

    extraConfigLua = ''
      local get_option = vim.filetype.get_option
      vim.filetype.get_option = function(filetype, option)
        return option == "commentstring"
          and require("ts_context_commentstring.internal").calculate_commentstring()
          or get_option(filetype, option)
      end
    '';

    plugins = {
      typescript-tools = {
        enable = true;
        settings = {
          settings = {
            tsserver_max_memory = 8192;
            separate_diagnostic_server = false;
            expose_as_code_action = "all";
          };
        };
      };

      lsp = {
        enable = true;
        servers = {
          eslint.enable = true;
          yamlls.enable = true;
          jsonls.enable = true;
          html.enable = true;
          graphql.enable = true;
          cssls.enable = true;
          tailwindcss = {
            enable = true;
            filetypes = [
              "svelte"
              "html"
              "css"
              "postcss"
              "typescriptreact"
              "javascriptreact"
            ];
          };
        };
      };

      lsp-lines.enable = true;
      indent-blankline.enable = true;
      sleuth.enable = true;
      treesitter = {
        enable = true;
        folding = true;
        nixvimInjections = true;
        settings.highlight.enable = true;
      };
      neo-tree = {
        enable = true;
        closeIfLastWindow = true;
        filesystem.followCurrentFile = {
          enabled = true;
          leaveDirsOpen = true;
        };
      };
      telescope = {
        enable = true;
        extensions.fzf-native.enable = true;
        extensions.file-browser.enable = true;
      };
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            # { name = "copilot"; }
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-e>" = "cmp.mapping.close()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<CR>" = "cmp.mapping.confirm({ select = false })";
            "<C-p>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<C-n>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
        };
      };
      dressing.enable = true;
      fidget.enable = true;
      git-conflict.enable = true;
      gitsigns.enable = true;
      hmts.enable = true;
      illuminate.enable = true;
      lazygit.enable = true;
      markdown-preview.enable = true;
      nix.enable = true;
      spider = {
        enable = true;
        keymaps.motions = {
          b = "B";
          e = "E";
          ge = "gE";
          w = "W";
        };
        skipInsignificantPunctuation = false;
      };

      twilight.enable = true;
      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            javascript = [
              [
                "prettierd"
                "prettier"
              ]
            ];
            typescript = [
              [
                "prettierd"
                "prettier"
              ]
            ];
            html = [
              [
                "prettierd"
                "prettier"
              ]
            ];
            css = [
              [
                "prettierd"
                "prettier"
              ]
            ];
            markdown = [
              [
                "prettierd"
                "prettier"
              ]
            ];
            json = [
              [
                "prettierd"
                "prettier"
              ]
            ];
            yaml = [
              [
                "prettierd"
                "prettier"
              ]
            ];
            graphql = [
              [
                "prettierd"
                "prettier"
              ]
            ];
          };
          format_on_save.lsp_format = "fallback";
          notify_on_error = true;
        };
      };

      ts-context-commentstring = {
        enable = true;
        extraOptions.enable_autocmd = false;
      };

      spectre = {
        # Search and replace
        enable = true;
        findPackage = pkgs.ripgrep;
        settings = {
          default.replace.cmd = "oxi";
          live_update = true;
        };
      };

      mini = {
        enable = true;
        modules = {
          clue = {
            triggers = [
              {
                mode = "n";
                keys = "<leader>";
              }
              {
                mode = "n";
                keys = "g";
              }
            ];
          };
          surround = { };
        };
      };

      web-devicons.enable = true;
    };
  };
}
