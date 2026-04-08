#!/bin/bash

# Used for snippet frontend project
# like React Aria zip file downloads
#
# Summary:
# - Initializes a Git repository,
# - Creates a .gitignore,
# - Removes legacy lockfiles.
# - Installs dependencies with pnpm
# - Makes an initial commit

if [ ! -d ".git" ]; then
  git init
  echo "Initialized empty Git repository."
else
  echo "Git repository already exists. Skipping init."
fi

cat <<EOF >.gitignore
# Dependencies
node_modules/
.pnp/
.pnp.js

# Testing & Coverage
coverage/
*.lcov

# Build & Output
dist/
build/
out/
.next/
.turbo/

# Logs
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*

# Environment
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# OS / IDE
.DS_Store
Thumbs.db
.vscode/
.idea/
*.suo
*.ntvs*
*.njsproj
*.sln
*.sw?

# pnpm specific
pnpm-lock.yaml
EOF
echo ".gitignore created."

rm -f package-lock.json yarn.lock
echo "Legacy lockfiles removed."

if [ -f "package.json" ]; then
  echo "Starting pnpm install..."
  pnpm install --shamefully-hoist
else
  echo "No package.json found. Skipping pnpm install."
fi

echo "Finalizing Git..."
git add .
git commit -m "initialize project"

echo "----------------------------------------"
echo "Setup complete. Repository initialized and dependencies linked."
