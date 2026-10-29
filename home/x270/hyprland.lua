-- Hyprland Lua API. Use the panel's native resolution at scale 1.
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
hl.config({
    general = {
        gaps_in = 5, gaps_out = 10, border_size = 2, layout = "dwindle",
        col = {
            active_border = { colors = { "rgb(89b4fa)", "rgb(b4befe)" }, angle = 45 },
            inactive_border = "rgb(313244)",
        },
    },
    decoration = {
        rounding = 10,
        shadow = { enabled = false },
        blur = { enabled = false },
    },
    animations = { enabled = false },
    input = { kb_layout = "jp", follow_mouse = 0 },
    dwindle = { preserve_split = true },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        force_default_wallpaper = 0,
        background_color = "rgb(11111b)",
    },
})

-- Floating windows keep their geometry when other applications start/exit.
hl.window_rule({ name = "agent-desktop", match = { class = ".*" }, float = true })

hl.bind("SUPER + RETURN", hl.dsp.exec_cmd("uwsm app -- foot"))
hl.bind("SUPER + R", hl.dsp.exec_cmd("uwsm app -- fuzzel"))
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("uwsm app -- fuzzel"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("uwsm app -- thunar"))
hl.bind("SUPER + B", hl.dsp.exec_cmd("uwsm app -- microsoft-edge"))
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + SHIFT + M", hl.dsp.exec_cmd("uwsm stop"))
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("SUPER + left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5%"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })
for i = 1, 9 do
    hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = i }))
    if i <= 5 then
        hl.workspace_rule({ workspace = tostring(i), persistent = true })
    end
end

-- Match the normal UWSM autostart path: finalize only after Wayland is ready.
hl.on("hyprland.start", function()
    hl.exec_cmd("uwsm finalize")
end)
