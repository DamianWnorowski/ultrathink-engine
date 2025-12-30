#!/usr/bin/env bash

# ULTRATHINK ε₀ FRACTAL WEIGHT ENGINE
# Production deployment script

set -euo pipefail

cargo build --release

# GPU driver check
if ! nvidia-smi &> /dev/null; then
  echo "🚫 NVIDIA GPU required"
  exit 1
fi

echo "🚀 ULTRATHINK ε₀ LIVE"
echo "📊 Dashboard: https://github.com/DamianWnorowski/ultrathink-engine"

# Run fractal engine
cargo run --release -- --resolution 3840x2160 --frames 10000

# Hot-reload test
cargo run --release -- --hot-reload config.json

echo "✅ ε₀ Foundation COMPLETE"
echo "⏭️  ε₁ Self-RE pipeline ready"