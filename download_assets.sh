#!/bin/bash

ASSETS_DIR="assets"
MODELS_DIR="$ASSETS_DIR/models"
AUDIO_DIR="$ASSETS_DIR/audio"

mkdir -p "$MODELS_DIR/characters"
mkdir -p "$MODELS_DIR/enemies"
mkdir -p "$MODELS_DIR/props"
mkdir -p "$AUDIO_DIR/sfx/combat"
mkdir -p "$AUDIO_DIR/sfx/footsteps"
mkdir -p "$AUDIO_DIR/sfx/ui"
mkdir -p "$AUDIO_DIR/sfx/enemies"
mkdir -p "$AUDIO_DIR/music"

echo "=========================================="
echo "  The Fallen One - Asset Downloader"
echo "=========================================="

# KayKit Skeletons (Enemies) - from GitHub
echo ""
echo "[1/3] Downloading KayKit Skeletons (Enemies)..."
curl -L -o skeletons.zip "https://github.com/KayKit-Game-Assets/KayKit-Character-Pack-Skeletons-1.0/archive/refs/heads/main.zip"
if [ -f skeletons.zip ] && [ -s skeletons.zip ]; then
    unzip -o skeletons.zip -d "$MODELS_DIR/enemies/"
    mv "$MODELS_DIR/enemies/KayKit-Character-Pack-Skeletons-1.0-main" "$MODELS_DIR/enemies/skeletons" 2>/dev/null
    rm skeletons.zip
    echo "Done! Saved to assets/models/enemies/skeletons/"
else
    echo "Failed to download from GitHub, trying alternative..."
    rm -f skeletons.zip
fi

# Quaternius - Free low poly characters
echo ""
echo "[2/3] Downloading Quaternius Fantasy Characters..."
curl -L -o fantasy_chars.zip "https://www.patreon.com/file?h=79548385" 2>/dev/null || echo "Skipped (requires Patreon)"

# Kenney - Props and environment
echo ""
echo "[3/3] Downloading Kenney Dungeon Props..."
curl -L -o kenney_dungeon.zip "https://kenney.nl/content/3d-assets/dungeon-kit/dungeon-kit.zip"
if [ -f kenney_dungeon.zip ] && [ -s kenney_dungeon.zip ]; then
    unzip -o kenney_dungeon.zip -d "$MODELS_DIR/props/"
    mv "$MODELS_DIR/props/dungeon-kit" "$MODELS_DIR/props/dungeon" 2>/dev/null
    rm kenney_dungeon.zip
    echo "Done! Saved to assets/models/props/dungeon/"
else
    rm -f kenney_dungeon.zip
    echo "Skipped"
fi

echo ""
echo "=========================================="
echo "  Asset Structure Created!"
echo "=========================================="
echo ""
echo "Folders ready:"
echo "  assets/models/characters/  <- Put player models here"
echo "  assets/models/enemies/     <- Enemy models (skeletons downloaded)"
echo "  assets/models/props/       <- Environment props"
echo "  assets/audio/sfx/          <- Sound effects"
echo "  assets/audio/music/        <- Background music"
echo ""
echo "=========================================="
echo "  MANUAL DOWNLOAD REQUIRED:"
echo "=========================================="
echo ""
echo "1. KayKit Adventurers (Player):"
echo "   https://kaylousberg.itch.io/kaykit-adventurers"
echo "   -> Click 'Download Now' (Free)"
echo "   -> Extract to: assets/models/characters/adventurers/"
echo ""
echo "2. Sound Effects:"
echo "   https://freesound.org/browse/tags/sword/"
echo "   -> Sign up (free)"
echo "   -> Download sword/attack sounds"
echo "   -> Save to: assets/audio/sfx/combat/"
echo ""
echo "3. Background Music:"
echo "   https://opengameart.org/art-search?keys=dark+fantasy"
echo "   -> Save to: assets/audio/music/"
echo ""