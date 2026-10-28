cli="$HOME/develop/kaname-ai-satellite/node_modules/@earendil-works/pi-coding-agent/dist/cli.js"
if [[ ! -f "$cli" ]]; then
  echo 'Run x270-agent-setup first.' >&2
  exit 1
fi
exec node "$cli" "$@"
