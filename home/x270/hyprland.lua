-- Hyprland 0.55 Lua API. Use the panel's native resolution at scale 1.
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
hl.config({
    general = { gaps_in = 2, gaps_out = 2, border_size = 1, layout = "dwindle" },
    decoration = {
        rounding = 0,
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
        background_color = "rgb(202020)",
    },
})

-- Floating windows keep their geometry when other applications start/exit.
hl.window_rule({ name = "agent-desktop", match = { class = ".*" }, float = true })

hl.bind("SUPER + RETURN", hl.dsp.exec_cmd("uwsm app -- foot"))
hl.bind("SUPER + R", hl.dsp.exec_cmd("uwsm app -- fuzzel"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("uwsm app -- thunar"))
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + SHIFT + M", hl.dsp.exec_cmd("uwsm stop"))
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
for i = 1, 9 do
    hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = i }))
end

-- Match the normal UWSM autostart path: finalize only after Wayland is ready.
hl.on("hyprland.start", function()
    hl.exec_cmd("uwsm finalize")
end)
