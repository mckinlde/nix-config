sudo nixos-rebuild switch -I nixos-config=./configuration.nix
git add .
# ToDo: use an LLM to read git diff and generate a better commit msg
git commit -m "run ./nrs.sh"
git push
