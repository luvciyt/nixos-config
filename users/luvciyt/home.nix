# users/luvciyt/home.nix
{ lib, pkgs, ... }:

{
  home = {
    username = "luvciyt";
    homeDirectory = lib.mkForce "/home/luvciyt";
    stateVersion = "25.05";

    packages = with pkgs; [
      whitesur-icon-theme
      whitesur-cursors

      # cpp libs
      eigen

      docker 
      docker-compose

      wemeet

      gcc
      gdb
      clang-tools

      flex
      bison
      bc

      ninja
      gnumake

      fzf

      zip
      unzip

      ffmpeg
      flameshot
      feh

      nerd-fonts.jetbrains-mono
      jetbrains-mono

      jetbrains.clion
      jetbrains.rust-rover
      # proxy
      flclash

      # browser
      google-chrome

      qq

      pkgs.sassc
      pkgs.glib.dev
      pkgs.glib.bin
      pkgs.libxml2
      pkgs.imagemagick
      pkgs.dialog
      pkgs.optipng
      pkgs.inkscape

      gnome-tweaks
      dconf

      # GNOME shell extensions
      gnomeExtensions.user-themes
      gnomeExtensions.dash-to-dock
      gnomeExtensions.appindicator
      gnomeExtensions.blur-my-shell
      gnomeExtensions.system-monitor
      gnomeExtensions.docker
      gnomeExtensions.kimpanel
    ];

    sessionVariables = {
      EDITOR = "nvim";
      TERMINAL = "gnome-terminal";
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "WhiteSur-Dark-red";
    };
    iconTheme = {
      name = "WhiteSur";
      package = pkgs.whitesur-icon-theme;
    };
    cursorTheme = {
      name = "WhiteSur-cursors";
      package = pkgs.whitesur-cursors;
    };
    font = {
      name = "PingFang SC";
      size = 11;
    };
  };
  programs.gnome-shell.theme.name = "WhiteSur-Dark-red";
  dconf.enable = true;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      clock-show-weekday = true;
      clock-show-seconds = true;
    };

    # 日历设置
    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };
    # layout
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "close,minimize,maximize:appmenu";
    };

    # keybinds
    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Control>e" ];
    };

    "org/gnome/shell/extensions/user-theme" = {
      name = "WhiteSur-Dark-red";
    };

    "org/gnome/desktop/wm/preferences" = {
      theme = "WhiteSur-Dark-red";
      titlebar-font = "PingFang SC Bold 11";
    };

    # shell extensions
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "dash-to-dock@micxgx.gmail.com"
        "blur-my-shell@aunetx"
        "system-monitor@paradoxxx.zero.gmail.com"
        "docker@stickman_0x00.com"
        "kimpanel@kde.org"
        "appindicatorsupport@rgcjonas.gmail.com"
        "system-monitor@gnome-shell-extensions.gcampax.github.com"
      ];
    };
  };

  xdg.configFile."nvim".source = ./nvim;
  home.file.".themes".source = ./themes;

  programs = {
    git = {
      enable = true;
      userName = "luvciyt";
      userEmail = "arce.domartic@gmail.com";

      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
        push.default = "simple";

        core = {
          editor = "nvim";
          autocrlf = "input";
        };

        alias = {
          st = "status";
          ci = "commit";
          br = "branch";
          co = "checkout";
          df = "diff";
          lg = "log --oneline --graph --decorate --all";
        };
      };
    };

    vscode = {
      enable = true;

      profiles.default = {
        userSettings = {
          "editor.fontSize" = 15;
          "workbench.colorTheme" = "Tokyo Night";
          "files.autoSave" = "afterDelay";
          "editor.tabSize" = 4;
          "editor.wordWrap" = "on";
          "editor.fontFamily" = "JetBrains Mono";
          "terminal.integrated.defaultProfile.linux" = "zsh";
          "terminal.integrated.fontFamily" = "JetBrains Mono";

          "nix.enableLanguageServer" = true;
          "nix.formatter" = "nixpkgs-fmt";

          "locale" = "zh-cn";

          "C_Cpp.intelliSenseEngine" = "disabled";
          "clangd.detect" = true;
          "clangd.arguments" = [
            "--background-index"
            "--clang-tidy"
            "--clang-tidy-checks=*"
          ];
        };

        extensions = with pkgs.vscode-extensions; [
          github.copilot
          # nix related plugins
          jnoortheen.nix-ide
          # nixos.vscode-nixpkgs-fmt

          ms-ceintl.vscode-language-pack-zh-hans

          # cpp support
          ms-vscode.cpptools
          ms-vscode.cmake-tools
          llvm-vs-code-extensions.vscode-clangd

          rust-lang.rust-analyzer
          esbenp.prettier-vscode
          yzhang.markdown-all-in-one
          eamodio.gitlens
          ms-azuretools.vscode-docker
          redhat.vscode-yaml

          # themes
          enkia.tokyo-night
        ];

        enableExtensionUpdateCheck = false;
        enableUpdateCheck = false;
      };
    };

    zsh = {
      enable = true;

      history = {
        expireDuplicatesFirst = true;
        extended = true;
        share = true;
        size = 10000;
        save = 10000;
      };

      shellAliases = {
        vim = "nvim";
        ll = "ls -la";
        la = "ls -la";
        grep = "grep --color=auto";
        ".." = "cd ..";
        "..." = "cd ../..";
        cls = "clear";
        lgen = "nixos-rebuild list-generations";
      };

      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";

        plugins = [
          "git"
          "vi-mode"
          "docker"
          "kubectl"
          "history-substring-search"
          "colored-man-pages"
          "extract"
          "z"
        ];
      };

      plugins = [
        {
          name = "zsh-autosuggestions";
          src = pkgs.zsh-autosuggestions;
          file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
        }
        {
          name = "zsh-syntax-highlighting";
          src = pkgs.zsh-syntax-highlighting;
          file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
        }
        {
          name = "zsh-history-substring-search";
          src = pkgs.zsh-history-substring-search;
          file = "share/zsh-history-substring-search/zsh-history-substring-search.zsh";
        }
        {
          name = "zsh-completions";
          src = pkgs.zsh-completions;
          file = "share/zsh-completions/zsh-completions.plugin.zsh";
        }
        {
          name = "zsh-z";
          src = pkgs.zsh-z;
          file = "share/zsh-z/zsh-z.plugin.zsh";
        }
        {
          name = "zsh-vi-mode";
          src = pkgs.zsh-vi-mode;
          file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        }
      ];

      initContent = ''
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi

        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

        export EDITOR="nvim"
        export VISUAL="nvim"

        mkcd() {
          mkdir -p "$1" && cd "$1"
        }

        h() {
          if [ -z "$1" ]; then
            history
          else
            history | grep "$1"
          fi
        }

        bindkey '^[[A' history-substring-search-up
        bindkey '^[[B' history-substring-search-down
        bindkey '^[[1;5C' forward-word
        bindkey '^[[1;5D' backward-word

        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
        zstyle ':completion:*' menu select

        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
      '';
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      plugins = with pkgs.vimPlugins; [
        plenary-nvim
        nvim-web-devicons

        tokyonight-nvim
        lualine-nvim
        bufferline-nvim

        nvim-tree-lua
        telescope-nvim
        vim-tmux-navigator
        (nvim-treesitter.withAllGrammars)
        rainbow-delimiters-nvim
        comment-nvim
        nvim-autopairs
        gitsigns-nvim

        mason-nvim
        mason-lspconfig-nvim
        nvim-lspconfig

        nvim-cmp
        cmp-nvim-lsp
        cmp-path
        cmp-buffer

        luasnip
        cmp_luasnip
        friendly-snippets
      ];
    };
  };

  services = {
    syncthing = {
      enable = false;
    };
  };

  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      desktop = "$HOME/桌面";
      documents = "$HOME/文档";
      download = "$HOME/下载";
      music = "$HOME/音乐";
      pictures = "$HOME/图片";
      videos = "$HOME/视频";
      templates = "$HOME/模板";
      publicShare = "$HOME/公共";
    };
  };

}
