{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  programs.uwsm.waylandCompositors.hyprland = {
    prettyName = "Hyprland";
    binPath = "/run/current-system/sw/bin/Hyprland";
  };

  # One automatic login after boot. Logging out returns to a text greeter.
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings = {
      initial_session = {
        user = "sandyman";
        command = "${pkgs.uwsm}/bin/uwsm start -F -- /run/current-system/sw/bin/Hyprland";
      };
      default_session = {
        command = "${pkgs.greetd}/bin/agreety --cmd '${pkgs.uwsm}/bin/uwsm start -F -- /run/current-system/sw/bin/Hyprland'";
      };
    };
  };

  hardware.graphics.enable = true;
  services.libinput.enable = true;
  security.polkit.enable = true;
  security.rtkit.enable = true;
  programs.ydotool.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  services.gvfs.enable = true;
  programs.thunar.enable = true;
  programs.dconf.enable = true;
  services.gnome.at-spi2-core.enable = true;

  # Hyprland's module supplies its portal and the GTK file-picker fallback.
  xdg.portal.config.hyprland = {
    default = [
      "hyprland"
      "gtk"
    ];
    "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-mozc
    ];
    fcitx5.waylandFrontend = true;
    fcitx5.settings.inputMethod = {
      "Groups/0" = {
        Name = "Default";
        "Default Layout" = "jp";
        DefaultIM = "mozc";
      };
      "Groups/0/Items/0" = {
        Name = "keyboard-jp";
        Layout = "";
      };
      "Groups/0/Items/1" = {
        Name = "mozc";
        Layout = "";
      };
      GroupOrder."0" = "Default";
    };
  };
  fonts.packages = with pkgs; [
    dejavu_fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.hack
  ];
}
