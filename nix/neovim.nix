{ config, lib, pkgs, ... }:

let
  cfg = config.programs.neovim-config;
  lspPackages = with pkgs; [
    nixd
    lua-language-server
    pyright
    rust-analyzer
  ];
  neovimWithLSP = pkgs.symlinkJoin {
    name = "neovim";
    paths = [ pkgs.neovim ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/nvim \
        --prefix PATH : ${lib.makeBinPath lspPackages}
    '';
  };
in
{
  options.programs.neovim-config = {
    enable = lib.mkEnableOption "neovim";

    defaultEditor = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Set neovim as the default $EDITOR.";
    };

    defaultManPager = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Set neovim as the default $MANPAGER.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ neovimWithLSP ];

    environment.sessionVariables = lib.mkMerge [
      (lib.mkIf cfg.defaultEditor { EDITOR = "nvim"; })
      (lib.mkIf cfg.defaultManPager { MANPAGER = "nvim +Man!"; })
    ];
  };
}
