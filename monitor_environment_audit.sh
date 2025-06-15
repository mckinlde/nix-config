#!/usr/bin/env bash
set -euo pipefail

echo
echo "=== Checking system-wide shell startup files for scaling ==="
sys_files=(
  "/etc/profile"
  "/etc/bash.bashrc"
  "/etc/environment"
)
for file in "${sys_files[@]}"; do
  if [[ -f "$file" ]]; then
    echo "--- $file ---"
    grep -E 'monitor=|scale=|GDK_SCALE|QT_SCALE_FACTOR|WAYLAND_SCALE' "$file" || echo "(no matches)"
  else
    echo "--- $file does not exist"
  fi
done

echo
echo "=== Checking for Home Manager shell configuration (nix files) ==="
find "$HOME/.config/nixpkgs" -type f \( -name "*.nix" -o -name "*.nix.in" \) -exec grep -H 'scale\|GDK_SCALE\|QT_SCALE_FACTOR\|WAYLAND_SCALE' {} + 2>/dev/null || echo "(no matches)"

echo
echo "=== Checking known hyprland.conf locations ==="
for file in "$HOME/.config/hypr/hyprland.conf" "$HOME/hyprland.conf"; do
  if [[ -f "$file" ]]; then
    echo "--- $file ---"
    grep -E '^monitor=|scale=' "$file" || echo "(no matches)"
  fi
done

echo
echo "=== Searching Hyprland config for monitor and scale settings ==="
grep -H -rE '^(monitor|scale)=' ~/.config/hypr/ || echo "(no matches)"

echo
echo "=== Checking environment variables related to scaling (from shell) ==="
for var in GDK_SCALE QT_SCALE_FACTOR WAYLAND_SCALE; do
  echo "$var=${!var-<not set>}"
done

echo
echo "=== Effective environment variables (via env | grep -i scale) ==="
env | grep -i scale || echo "(no matches)"

echo
echo "=== Checking common shell and desktop startup files for monitor or scale settings ==="
files=(
  ~/.bash_profile
  ~/.profile
  ~/.bashrc
  ~/.zshrc
  ~/.xprofile
  ~/.xinitrc
)
for file in "${files[@]}"; do
  if [[ -f "$file" ]]; then
    echo "--- $file ---"
    grep -E 'monitor=|scale=|GDK_SCALE|QT_SCALE_FACTOR|WAYLAND_SCALE' "$file" || echo "(no matches)"
  else
    echo "--- $file does not exist"
  fi
done

echo
echo "=== Checking ~/.config/environment.d/*.conf for scaling settings ==="
envdir="$HOME/.config/environment.d"
if [[ -d "$envdir" ]]; then
  for f in "$envdir"/*.conf; do
    [[ -e "$f" ]] || continue
    echo "--- $f ---"
    grep -E 'monitor=|scale=|GDK_SCALE|QT_SCALE_FACTOR|WAYLAND_SCALE' "$f" || echo "(no matches)"
  done
else
  echo "--- $envdir does not exist"
fi

echo
echo "=== Current monitors from hyprctl (JSON) ==="
hyprctl monitors -j || echo "hyprctl command failed"

echo
echo "=== Firefox environment block (if running) ==="
pid=$(pgrep -n firefox || true)
if [[ -n "$pid" ]]; then
  echo "Firefox PID: $pid"
  if [[ -r "/proc/$pid/environ" ]]; then
    tr '\0' '\n' < "/proc/$pid/environ" | grep -i scale || echo "(no scaling vars in Firefox env)"
  else
    echo "Cannot read environment of Firefox (permission denied?)"
  fi
else
  echo "Firefox is not running"
fi

echo
echo "=== Done ==="

