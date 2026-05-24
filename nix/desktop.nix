{ config, lib, pkgs, ... }:

let
  cfg = config.siga.desktop;
in
{
  imports = [ ./gnome.nix ];

  options.siga.desktop = {
    enable = lib.mkEnableOption "desktop support (X server and audio pipeline)";

    environment = lib.mkOption {
      type = lib.types.enum [ "gnome" ];
      default = "gnome";
      description = "Which desktop environment to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;

    services.xserver.xkb = {
      layout = "us,ru";
      variant = "";
      options = "grp:win_space_toggle";
    };

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
