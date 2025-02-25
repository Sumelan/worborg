{
  lib,
  config,
  ...
}:
{
  options.custom = with lib; {
    kitty.enable = mkEnableOption "kitty" // {
      default = true;
    };
  };

  config = lib.mkIf config.custom.kitty.enable {
    programs.kitty = {
      enable = true;
      settings = {
        enable_audio_bell = false;
        copy_on_select = "clipboard";
        cursor_trail = 1;
        cursor_trail_start_threshold = 10;
        scrollback_lines = 10000;
        update_check_interval = 0;
        tab_bar_edge = "top";
        confirm_os_window_close = 0;
        # for removing kitty padding when in neovim
        allow_remote_control = "password";
        remote_control_password = ''"" set-spacing''; # only allow setting of padding
        listen_on = "unix:/tmp/kitty-socket";
      };
    };

    home.shellAliases = {
      # change color on ssh
      ssh = "kitten ssh --kitten=color_scheme=Dracula";
    };

    # remove padding while in neovim
    # programs.nixvim.extraConfigLua = ''
    #   vim.api.nvim_create_autocmd("VimEnter", {
    #     callback = function()
    #       if vim.env.TERM == "xterm-kitty" then
    #         vim.fn.system(string.format('kitty @ --to %s set-spacing padding=0', vim.env.KITTY_LISTEN_ON))
    #       end
    #     end
    #   })

    #   vim.api.nvim_create_autocmd("VimLeave", {
    #     callback = function()
    #       if vim.env.TERM == "xterm-kitty" then
    #         vim.fn.system(string.format('kitty @ --to %s set-spacing padding=${toString terminal.padding}', vim.env.KITTY_LISTEN_ON))
    #       end
    #     end
    #   })
    # '';
  };
}
