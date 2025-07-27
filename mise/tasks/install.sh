#!/usr/bin/env bash
# mise description="Install and setup Gesttalt dependencies"

set -euo pipefail

echo "🌱 Setting up Gesttalt..."
echo ""

echo "📦 Installing Mix dependencies..."
mix deps.get

echo ""
echo "🗄️  Setting up database..."
mix ecto.setup

echo ""
echo "✅ Setup complete! Run 'mix phx.server' to start the server."
