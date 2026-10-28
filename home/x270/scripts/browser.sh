# Separate from the human browser profile. CDP is enabled only on request.
profile="${1:-default}"
if (( $# > 0 )); then shift; fi
if [[ ! "$profile" =~ ^[a-zA-Z0-9_-]+$ ]]; then
  echo 'Profile name must contain only letters, digits, underscores or hyphens.' >&2
  exit 2
fi
directory="${XDG_DATA_HOME:-$HOME/.local/share}/chromium-agent/$profile"
mkdir -p "$directory"
chmod 700 "$directory"
args=(--user-data-dir="$directory" --ozone-platform=wayland --force-renderer-accessibility)
if [[ -n "${CDP_PORT:-}" ]]; then
  if [[ ! "$CDP_PORT" =~ ^[0-9]+$ ]] || (( CDP_PORT < 1024 || CDP_PORT > 65535 )); then
    echo 'CDP_PORT must be a port between 1024 and 65535.' >&2
    exit 2
  fi
  args+=(--remote-debugging-address=127.0.0.1 --remote-debugging-port="$CDP_PORT")
fi
exec chromium "${args[@]}" "$@"
