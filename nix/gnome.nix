{ config, lib, pkgs, ... }:

let
  cfg = config.siga.desktop;
in
{
  config = lib.mkIf (cfg.enable && cfg.environment == "gnome") {
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    services.gnome.gnome-keyring.enable = true;

    environment.systemPackages = with pkgs; [
      gnomeExtensions.appindicator
      gnomeExtensions.caffeine
      gnomeExtensions.hot-edge
      gnomeExtensions.media-controls
      gnomeExtensions.removable-drive-menu
      gnomeExtensions.tiling-assistant
    ];
  };
}
