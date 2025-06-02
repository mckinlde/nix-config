sudo nixos-rebuild switch -I nixos-config=./configuration.nix
git add .
git commit -m "run ./nrs.sh"
git push
