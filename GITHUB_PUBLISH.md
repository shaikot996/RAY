# Publishing RAY to GitHub

## Requirements

On EndeavourOS / Arch Linux:

```bash
sudo pacman -S --needed git github-cli unzip
```

Authenticate once:

```bash
gh auth login
```

## Create the public repository and push

From inside the local `RAY` directory:

```bash
git init -b main
git add .
git commit -m "Initial public release: RAY v1.0.0"
gh repo create RAY --public --description "RAY — Relativity and Geometry Toolkit for Wolfram Language" --source=. --remote=origin --push
```

The `--source=.` flag tells GitHub CLI to use the current local Git repository, and `--push` pushes the committed branch after creating the remote repository.
