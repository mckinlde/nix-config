#!/usr/bin/env bash

set -e  # exit on any failure

usage() {
  cat <<EOF
Usage: $0 [commit-message]

Runs 'nixos-rebuild switch' with the local configuration.nix, then commits
and pushes the changes to git.

If no commit message is provided, a default message will be used.

Options:
  -h, --help    Show this help message and exit.

Examples:
  $0                        # Uses default commit message
  $0 "Update nix config"    # Uses provided commit message
EOF
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  usage
  exit 0
fi

commit_msg="${1:-"Update NixOS configuration via ./nrs.sh"}"

echo "Running nixos-rebuild..."
sudo nixos-rebuild switch -I nixos-config=./configuration.nix

echo "Build succeeded. Committing changes with message: $commit_msg"
git add .
git commit -m "$commit_msg"
git push

