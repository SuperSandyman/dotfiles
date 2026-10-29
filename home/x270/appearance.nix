{
  lib,
  pkgs,
  ...
}:
let
  # Render once at build time; swaybg only displays a static texture.
  wallpaper =
    pkgs.runCommand "x270-midnight-wallpaper.png"
      {
        nativeBuildInputs = [ pkgs.librsvg ];
      }
      ''
        rsvg-convert --width 1920 --height 1080 ${./theme/midnight.svg} > "$out"
      '';
in
{
  gtk = {
    enable = true;
    font = {
      name = "Noto Sans CJK JP";
      size = 10;
    };
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
  };
  home.pointerCursor = {
    enable = true;
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
  xdg.configFile."uwsm/env".text = lib.mkAfter ''
    export XCURSOR_THEME=Bibata-Modern-Ice
  '';

  programs.foot.settings.main = {
    include = "${./theme/foot.ini}";
    pad = "16x16";
  };
  programs.fuzzel.settings = {
    main = {
      include = "${./theme/fuzzel.ini}";
      font = "Hack Nerd Font:size=11";
      icon-theme = "Papirus-Dark";
      terminal = "${pkgs.foot}/bin/foot";
      prompt = "❯  ";
      width = 40;
      lines = 8;
      horizontal-pad = 20;
      vertical-pad = 14;
      inner-pad = 12;
      layer = "overlay";
    };
    border = {
      width = 2;
      radius = 14;
    };
  };
  services.mako.settings = {
    font = "Noto Sans CJK JP 10";
    background-color = "#1e1e2eff";
    text-color = "#cdd6f4ff";
    border-color = "#89b4faff";
    progress-color = "over #313244ff";
    border-size = 2;
    border-radius = 12;
    width = 340;
    padding = "14";
    margin = "54,12,0";
    default-timeout = 6500;
    max-visible = 3;
    max-icon-size = 32;
    "urgency=critical" = {
      border-color = "#f38ba8ff";
      default-timeout = 0;
    };
  };

  # Native modules only: no recurring shell scripts or HTTP polling.
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      targets = [ "graphical-session.target" ];
    };
    style = builtins.readFile ./theme/mocha.css + "\n" + builtins.readFile ./theme/waybar.css;
    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 32;
      margin = "8 10 0 10";
      spacing = 2;
      exclusive = true;
      fixed-center = true;
      modules-left = [
        "custom/launcher"
        "ext/workspaces"
      ];
      modules-center = [ "clock" ];
      modules-right = [
        "cpu"
        "memory"
        "network"
        "pulseaudio"
        "backlight"
        "upower"
        "tray"
      ];
      "custom/launcher" = {
        format = "";
        tooltip-format = "Applications · Super + Space";
        on-click = "${pkgs.fuzzel}/bin/fuzzel";
      };
      "ext/workspaces" = {
        format = "{name}";
        sort-by-name = true;
        on-click = "activate";
        ignore-hidden = false;
      };
      clock = {
        interval = 60;
        format = "{:%a %d %b  ·  %H:%M}";
        format-alt = "{:%Y / %m / %d  ·  %H:%M}";
        tooltip-format = "<big>{:%Y年 %m月}</big>\n<tt><small>{calendar}</small></tt>";
      };
      cpu = {
        interval = 5;
        format = " {usage}%";
        on-click = "${pkgs.foot}/bin/foot -e ${pkgs.btop}/bin/btop";
      };
      memory = {
        interval = 10;
        format = "󰍛 {used:0.1f}G";
        tooltip-format = "Memory: {used:0.1f} / {total:0.1f} GiB";
      };
      network = {
        interval = 10;
        format-wifi = "";
        format-ethernet = "󰈀";
        format-disconnected = "󰖪";
        tooltip-format-wifi = "{essid} · {signalStrength}%\n{ipaddr}";
        tooltip-format-ethernet = "{ifname}\n{ipaddr}";
        tooltip-format-disconnected = "Offline";
        on-click = "${pkgs.foot}/bin/foot -e ${pkgs.networkmanager}/bin/nmtui";
      };
      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = "󰖁 muted";
        format-icons.default = [
          ""
          ""
          ""
        ];
        scroll-step = 5;
        on-click = "${pkgs.foot}/bin/foot -e ${pkgs.alsa-utils}/bin/alsamixer";
        on-click-right = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      };
      backlight = {
        format = "󰃟 {percent}%";
        scroll-step = 5;
      };
      # UPower's display device combines the X270's internal/external batteries.
      upower = {
        format = "{percentage}";
        icon-size = 16;
        hide-if-empty = true;
        tooltip = true;
      };
      tray = {
        icon-size = 16;
        spacing = 10;
      };
    };
  };

  xdg.configFile."wallpapers/x270-midnight.png".source = wallpaper;
  systemd.user.services.x270-wallpaper = {
    Unit = {
      Description = "X270 static wallpaper";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };
    Service = {
      ExecStart = "${pkgs.swaybg}/bin/swaybg --image ${wallpaper} --mode fill";
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
