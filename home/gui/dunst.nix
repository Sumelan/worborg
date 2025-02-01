{
  config,
  lib,
  ...
}:
let
  opacity = "E5"; # 90%
in
(lib.mkMerge [
  {
    services.dunst = {
      enable = true;
      settings = {
        global = {
          browser = "brave -new-tab";
          corner_radius = 8;
          dmenu = "rofi -p dunst:";
          enable_recursive_icon_lookup = true;
          ellipsize = "end";
          follow = "mouse";
          font = "${config.custom.fonts.regular} 12";
          frame_color = "{{background}}";
          frame_width = 0;
          horizontal_padding = 10;
          # icon_theme will be read from $XDG_DATA_HOME/icons, these are symlinked in gtk.nix
          icon_theme = config.gtk.iconTheme.name;
          icon_path = lib.mkForce "";
          max_icon_size = 72;
          mouse_left_click = "do_action";
          mouse_middle_click = "do_action";
          mouse_right_click = "close_current";
          separator_color = "{{color7}}";
          separator_height = 1;
          show_indicators = "no";
        };

        urgency_critical = {
          background = "{{color1}}";
          foreground = "{{foreground}}";
          timeout = 0;
        };

        urgency_low = {
          background = "{{background}}${opacity}";
          foreground = "{{foreground}}";
          timeout = 10;
        };

        urgency_normal = {
          background = "{{background}}${opacity}";
          foreground = "{{foreground}}";
          timeout = 10;
        };
      };
    };
  }

  (lib.mkIf config.services.dunst.enable {
    # create symlink in $XDG_DATA_HOME/.icons for each icon accent variant
    # allows dunst to be able to refer to icons by name
    xdg.dataFile = lib.mapAttrs' (
      accent: _:
      let
        iconTheme = "Tela-${accent}-dark";
      in
      lib.nameValuePair "icons/${iconTheme}" {
        source = "${config.gtk.iconTheme.package}/share/icons/${iconTheme}";
      }
    ) config.custom.gtk.accents;
  })
])
