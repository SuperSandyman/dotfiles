{ pkgs, ... }:

let
  defaultPanelWidgets = [
    "org.kde.plasma.kickoff"
    "org.kde.plasma.pager"
    "org.kde.plasma.icontasks"
    "org.kde.plasma.marginsseparator"
    "org.kde.plasma.kimpanel"
    "org.kde.plasma.systemtray"
    "org.kde.plasma.digitalclock"
    "org.kde.plasma.showdesktop"
  ];
in
{
  programs.plasma = {
    enable = true;

    # Keep GUI changes possible while the migration is being verified.
    # Enabling this later makes the configuration fully authoritative.
    overrideConfig = false;

    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Kay/";
    };

    fonts = {
      general = {
        family = "Noto Sans CJK JP";
        pointSize = 10;
      };
      small = {
        family = "Noto Sans CJK JP";
        pointSize = 8;
      };
      toolbar = {
        family = "Noto Sans CJK JP";
        pointSize = 10;
      };
      menu = {
        family = "Noto Sans CJK JP";
        pointSize = 10;
      };
      windowTitle = {
        family = "Noto Sans CJK JP";
        pointSize = 10;
      };
    };

    input = {
      keyboard.layouts = [ { layout = "us"; } ];
      mice = [
        {
          name = "Logitech MX Ergo";
          vendorId = "046d";
          productId = "406f";
          acceleration = 0.2;
          scrollSpeed = 1.5;
        }
      ];
    };

    kscreenlocker = {
      timeout = 15;
      passwordRequiredDelay = 10;
    };

    powerdevil = {
      AC = {
        autoSuspend = {
          action = "sleep";
          idleTimeout = 1200;
        };
        dimDisplay = {
          enable = true;
          idleTimeout = 900;
        };
        turnOffDisplay.idleTimeout = 1800;
      };
      battery.autoSuspend = {
        action = "sleep";
        idleTimeout = 300;
      };
    };

    kwin = {
      virtualDesktops = {
        number = 1;
        rows = 1;
      };
      tiling.padding = 4;
    };

    panels = [
      {
        location = "bottom";
        screen = 0;
        widgets = defaultPanelWidgets;
      }
      {
        location = "bottom";
        screen = 1;
        widgets = defaultPanelWidgets;
      }
      {
        location = "bottom";
        screen = 2;
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.pager"
          {
            iconTasks.launchers = [
              "applications:systemsettings.desktop"
              "preferred://filemanager"
              "applications:org.kde.konsole.desktop"
              "applications:codex-desktop.desktop"
              "applications:code.desktop"
            ];
          }
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.kimpanel"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
          "org.kde.plasma.showdesktop"
        ];
      }
    ];

    shortcuts = {
      kwin = {
        "Walk Through Windows" = [
          "Alt+Tab"
          "Meta+Tab"
        ];
        "Walk Through Windows (Reverse)" = [
          "Alt+Shift+Tab"
          "Meta+Shift+Tab"
        ];
        "Window Quick Tile Left" = "Meta+Left";
        "Window Quick Tile Right" = "Meta+Right";
        "Window Quick Tile Top" = "Meta+Up";
        "Window Quick Tile Bottom" = "Meta+Down";
        "Window to Next Screen" = "Meta+Shift+Right";
        "Window to Previous Screen" = "Meta+Shift+Left";
      };
      plasmashell = {
        "activate application launcher" = [
          "Meta"
          "Alt+F1"
        ];
      };
      org_kde_powerdevil.powerProfile = [
        "Battery"
        "Meta+B"
      ];
    };

    configFile = {
      kdeglobals = {
        General = {
          AccentColor = "0,211,158";
          LastUsedCustomAccentColor = "0,211,158";
        };
        KDE.AnimationDurationFactor = 0.7071067811865475;
        "KFileDialog Settings" = {
          "Show Inline Previews" = true;
          "Show hidden files" = false;
          "Sort directories first" = true;
          "View Style" = "DetailTree";
        };
      };

      kwinrc = {
        Wayland."InputMethod[$e]" = "/run/current-system/sw/share/applications/org.fcitx.Fcitx5.desktop";
        Xwayland.Scale = 1;
      };

      dolphinrc = {
        MainWindow.MenuBar = "Disabled";
        "KFileDialog Settings" = {
          "Places Icons Auto-resize" = false;
          "Places Icons Static Size" = 22;
        };
      };

      ksplashrc.KSplash.Theme = "org.kde.breeze.desktop";
      plasmaparc.General.RaiseMaximumVolume = true;

      spectaclerc = {
        ImageSave.translatedScreenshotsFolder = "スクリーンショット";
        VideoSave.translatedScreencastsFolder = "画面録画";
      };
    };
  };

  programs.konsole = {
    enable = true;
    defaultProfile = "Profile 1";
    profiles."Profile 1" = {
      colorScheme = "Breeze";
      font = {
        name = "Hack Nerd Font";
        size = 11;
      };
    };
  };
}
