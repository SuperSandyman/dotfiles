{ pkgs, ... }:
let
  mkCommand =
    name: inputs: source:
    pkgs.writeShellApplication {
      inherit name;
      runtimeInputs = inputs;
      text = builtins.readFile source;
    };
  satellite = mkCommand "kaname-satellite" [ pkgs.nodejs_24 ] ./scripts/satellite.sh;
  pi = mkCommand "satellite-pi" [ pkgs.nodejs_24 ] ./scripts/pi.sh;
  piCheck = pkgs.writeShellApplication {
    name = "x270-pi-check";
    runtimeInputs = [ pkgs.nodejs_24 ];
    text = ''exec node ${./check-pi.mjs} "$@"'';
  };
  setup = mkCommand "x270-agent-setup" [
    pkgs.git
    pkgs.nodejs_24
    pkgs.coreutils
    pi
  ] ./scripts/setup.sh;
  capture = mkCommand "x270-gui-capture" [
    pkgs.coreutils
    pkgs.hyprland
    pkgs.grim
    pkgs.computer-use-linux
  ] ./scripts/capture.sh;
  doctor = mkCommand "x270-agent-doctor" [
    pkgs.coreutils
    pkgs.jq
    pkgs.hyprland
    pkgs.computer-use-linux
    pkgs.systemd
    piCheck
  ] ./scripts/doctor.sh;
  browser = mkCommand "chromium-agent" [ pkgs.chromium pkgs.coreutils ] ./scripts/browser.sh;
in
{
  home.packages = [
    satellite
    pi
    piCheck
    setup
    capture
    doctor
    browser
    pkgs.nodejs_24
  ];

  # Keep config/auth/state/history and Pi's extensible settings writable, outside
  # the store. Satellite spawns its own pinned Pi; satellite-pi uses that same CLI.
  systemd.user.services.kaname-satellite = {
    Unit = {
      Description = "Kaname Satellite on the X270 desktop";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
      ConditionPathExists = [
        "%h/.config/kaname-ai-satellite/config.yaml"
        "%h/develop/kaname-ai-satellite/dist/cli.js"
      ];
    };
    Service = {
      Type = "simple";
      WorkingDirectory = "%h/Workspace";
      ExecStartPre = "${pkgs.hyprland}/bin/hyprctl -j monitors";
      ExecStart = "${satellite}/bin/kaname-satellite start";
      Restart = "on-failure";
      RestartSec = 10;
      TimeoutStopSec = 30;
      KillMode = "control-group";
      UMask = "0077";
      Environment = [
        "PATH=/run/wrappers/bin:%h/.local/bin:%h/.nix-profile/bin:/etc/profiles/per-user/sandyman/bin:/run/current-system/sw/bin"
        "COMPUTER_USE_LINUX_BIN=${pkgs.computer-use-linux}/bin/computer-use-linux"
        "COMPUTER_USE_LINUX_SKIP_DOWNLOAD=1"
        "COMPUTER_USE_LINUX_INDICATOR=0"
        "YDOTOOL_SOCKET=/run/ydotoold/socket"
      ];
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
