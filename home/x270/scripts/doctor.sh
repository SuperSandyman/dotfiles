failed=0
for variable in XDG_RUNTIME_DIR WAYLAND_DISPLAY DBUS_SESSION_BUS_ADDRESS HYPRLAND_INSTANCE_SIGNATURE; do
  if [[ -z "${!variable:-}" ]]; then
    printf 'Missing session variable: %s\n' "$variable" >&2
    failed=1
  fi
done
hyprctl -j monitors | jq . || failed=1
hyprctl -j clients | jq . || failed=1
hyprctl configerrors || failed=1
if [[ ! -S /run/ydotoold/socket || ! -w /run/ydotoold/socket ]]; then
  echo 'ydotool socket missing or inaccessible; check group membership/service.' >&2
  failed=1
fi
if report="$(computer-use-linux doctor)"; then
  printf '%s\n' "$report" | jq .
  if ! printf '%s\n' "$report" | jq -e '.readiness |
    .can_build_accessibility_tree and .can_query_windows and
    .can_capture_screenshots and .can_send_development_input' >/dev/null; then
    failed=1
  fi
else
  failed=1
fi
x270-pi-check || failed=1
systemctl --user --no-pager status kaname-satellite.service || failed=1
exit "$failed"
