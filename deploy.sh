#!/bin/bash

git add .
git commit -m "update"
git push origin main




# ====== CONFIGURE THESE ======
REPO="https://github.com/tibane0/tibane0.github.io.git"
BRANCH="gh-pages"
BUILD_DIR="_site"
COMMIT_MSG="Deploying notes and blog updates: $(date +'%Y-%m-%d %H:%M:%S')"
# ==============================

# Exit on any error
set -e

echo "📦 Building site with Jekyll..."
bundle exec jekyll build

echo "🚀 Deploying to $BRANCH branch..."

# Navigate into build directory
cd "$BUILD_DIR"

if [ -d .git ]; then
	echo "cleaning up existing git repo in _site..."
	rm -rf .git
fi


# Initialize git in _site
git init
git checkout -b "$BRANCH"
git remote add origin "$REPO"

# Prevent GitHub Pages from using Jekyll
touch .nojekyll


# Add and commit
git add .
git commit -m "$COMMIT_MSG"

# Force push to gh-pages
git push -f origin "$BRANCH"

echo "✅ Deployed successfully to $BRANCH branch!"

