root="$HOME/develop/kaname-ai-satellite"
if [[ ! -f "$root/dist/cli.js" ]]; then
  echo 'Run x270-agent-setup first.' >&2
  exit 1
fi
exec node "$root/dist/cli.js" "$@"
