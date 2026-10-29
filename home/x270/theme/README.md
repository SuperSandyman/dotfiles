# X270 / Midnight

Catppuccin Mocha + blue/lavender accents, a compact Waybar, and an original static SVG wallpaper.
The checked-in theme files work offline; rebuilding does not fetch dotfiles or run upstream installers.

Adapted from the following public, MIT-licensed Catppuccin ports (retrieved 2026-10-29):

| Local file | Upstream | Upstream blob SHA |
| --- | --- | --- |
| `foot.ini` | [catppuccin/foot](https://github.com/catppuccin/foot/blob/main/themes/catppuccin-mocha.ini) | `bbe0ba38036b7089238df038770ff4f258b674e6` |
| `fuzzel.ini` | [catppuccin/fuzzel](https://github.com/catppuccin/fuzzel/blob/main/themes/catppuccin-mocha/blue.ini) | `f6ce89a7211b56a7b3fffa0ee737aee5533e6fd9` |
| `mocha.css` | [catppuccin/waybar](https://github.com/catppuccin/waybar/blob/main/themes/mocha.css) | `0eb6a826e3c6445a6f5516fcf1e29a9bc3b82a31` |

See [LICENSE](LICENSE) for the upstream license. `waybar.css` and `midnight.svg` are local designs.
Bar module choices follow [Waybar's documented configuration](https://github.com/Alexays/Waybar/wiki/Configuration).
Workspace buttons use [ext/workspaces](https://github.com/Alexays/Waybar/blob/0.15.0/man/waybar-ext-workspaces.5.scd)
and Hyprland's persistent workspace rules, so clicking them does not depend on legacy IPC dispatcher syntax.
The GTK theme, Papirus icons, and Bibata cursors are installed through Nixpkgs.
