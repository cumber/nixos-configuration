{ pkgs, lib, ... }:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;

    # Good place to install LSP servers that I want to be generally available.
    # LSP servers that are project-specific (e.g. for Haskell) should go in the
    # dev environments for those projects.
    extraPackages = [
      # LSP server for nix language
      pkgs.nil

      # LSP server for HTML, CSS, SCSS, and JSON
      pkgs.vscode-langservers-extracted

      # Better LSP server for HTML
      pkgs.superhtml

      # LSP server providing grammar and spell checking
      pkgs.ltex-ls

      # LSP server for markdown
      pkgs.marksman

      # LSP server for TOML
      pkgs.taplo-lsp

      # LSP server for typst
      pkgs.tinymist

      # LSP server for YAML
      pkgs.yaml-language-server
    ];

    settings = {
      theme = "onelight";

      editor = {
        cursor-shape.insert = "bar";

        indent-guides = {
          render = true;
          character = "⸽";
          skip-levels = 2;
        };

        statusline = {
          center = [ "file-type" ];
          right = [
            "diagnostics"
            "selections"
            "register"
            "position"
            "total-line-numbers"
            "file-encoding"
          ];
        };

        whitespace = {
          render = {
            tab = "all";
            nbsp = "all";
            nnbsp = "all";
          };

          characters = {
            tab = "→";
            tabpad = "·";
            nbsp = "⍽";
            nnbsp = "␣";
          };

          smart-tab.enable = false;
        };

        lsp = {
          enable = true;
          auto-signature-help = true;
          display-messages = true;
          display-inlay-hints = true;
          display-signature-help-docs = true;
          snippets = true;
        };
      };
    };

    languages = {
      language = [
        {
          name = "markdown";
          language-servers = [
            "marksman"
            "ltex-ls"
          ];
        }
        {
          name = "typst";
          language-servers = [
            "tinymist"
            "ltex-ls"
          ];
        }

        {
          name = "html";
          language-servers = [
            "superhtml"
          ];
        }
      ];

      language-server = {
        ltex-ls.config.ltex = {
          language = "en-AU";
          statusBarItem = true;
        };

        nil.config.nil = {
          formatting.command = [ (lib.getExe pkgs.nixfmt-rfc-style) ];
        };

        haskell-language-server = {
          command = "haskell-language-server";
          config = {
            provideFormatter = true;
            haskell.formattingProvider = "fourmolu";
          };
        };

        typescript-language-server = {
          config.preferences = {
            includeInlayEnumMemberValueHints = true;
            includeInlayFunctionLikeReturnTypeHints = true;
            includeInlayFunctionParameterTypeHints = true;
            includeInlayParameterNameHints = "all";
            includeInlayPropertyDeclarationTypeHints = true;
            includeInlayVariableTypeHints = true;
          };
        };

        vscode-json-language-server = {
          config = {
            provideFormatter = true;
            files.insertFinalNewline = true;
            json = {
              validate.enable = true;
              keepLines.enable = true;
            };
          };
        };
      };
    };
  };
}
