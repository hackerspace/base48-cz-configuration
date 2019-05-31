{ config, pkgs, lib, ... } :

with lib;

{
  options =
  {
    environment.editorIsVim = mkOption
    {
      default = true;
      example = true;
      type = with types; bool;
      description = ''
          There is only vim.
      '';
    };
  };

  config = mkIf config.environment.editorIsVim
  {
    environment.shellInit = ''
        export EDITOR=vim
    '';

    environment.systemPackages = [
      (pkgs.vim_configurable.customize {
        name = "vim";
        vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
          start = [ vim-nix sensible ]; # load plugin on startup
        };
      })
    ];
  };
}
