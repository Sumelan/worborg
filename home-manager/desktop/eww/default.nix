{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    eww.enable = mkEnableOption "eww" // {
      default = config.custom.niri.ebable;
    };
  };

  config = lib.mkIf config.custom.eww.enable {
    home = {
      file.".config/eww/statusbar/eww.css".source = ./eww.css;
      file.".config/eww/statusbar/eww.yuck".source = ./eww.yuck;
      file.".config/eww/statusbar/widgets/".source = ./widgets;

      packages = with pkgs; [
        eww
        jq
        socat
      ];
    };
  };
}
