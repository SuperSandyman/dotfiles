# Use the upstream lockfile at this revision, including bundled Pi 1.1.0.
revision=9150285d549c06fdec41db05fb9f71d40b633c6e
root="$HOME/develop/kaname-ai-satellite"
mkdir -p "$HOME/develop" "$HOME/Workspace"
if [[ ! -d "$root" ]]; then
  git clone git@github.com:SuperSandyman/kaname-ai-satellite.git "$root"
  git -C "$root" checkout --detach "$revision"
elif [[ "$(git -C "$root" rev-parse HEAD)" != "$revision" ]]; then
  echo "Existing Satellite checkout differs from $revision; leaving it untouched." >&2
  echo 'Review/update that checkout manually, then run npm ci && npm run build there.' >&2
  exit 1
fi
if ! git -C "$root" diff --quiet || ! git -C "$root" diff --cached --quiet; then
  echo 'Satellite has local changes; leaving the checkout untouched. Review them before setup.' >&2
  exit 1
fi
(
  cd "$root"
  npm ci
  npm run build
)
export COMPUTER_USE_LINUX_SKIP_DOWNLOAD=1
for package in \
  npm:@agent-sh/computer-use-linux@0.7.31 \
  npm:pi-lsp@0.1.7 \
  npm:pi-fff@0.1.13 \
  npm:pi-web-access@0.45.0 \
  npm:pi-redact@0.1.0; do
  satellite-pi install "$package"
done
echo 'Installed Satellite and all five Pi extensions.'
echo 'Next: kaname-satellite init; configure provider auth, then follow docs/x270.md.'
