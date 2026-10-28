base="${XDG_STATE_HOME:-$HOME/.local/state}/agent-artifacts"
mkdir -p "$base"
destination="$(mktemp -d "$base/$(date +%Y%m%dT%H%M%S)-XXXXXX")"
chmod 700 "$destination"
hyprctl -j monitors > "$destination/monitors.json" 2> "$destination/monitors.err" || true
hyprctl -j clients > "$destination/clients.json" 2> "$destination/clients.err" || true
hyprctl -j activewindow > "$destination/activewindow.json" 2> "$destination/activewindow.err" || true
grim "$destination/screen.png" 2> "$destination/screenshot.err" || true
computer-use-linux doctor > "$destination/doctor.json" 2> "$destination/doctor.err" || true
printf '%s\n' "$destination"
