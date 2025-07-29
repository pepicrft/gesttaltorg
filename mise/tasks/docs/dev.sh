#!/usr/bin/env bash
# mise description="Serve documentation locally with live reload"

#USAGE flag "--port <port>" help="Port to serve docs on" default="4001"
#USAGE flag "--open" help="Open browser after starting server"

set -euo pipefail

echo "📚 Building documentation..."

# Build the docs
mix docs

echo "🌐 Starting documentation server on http://localhost:${usage_port:-4001}"

# Check if --open flag is set
if [[ "${usage_open:-}" == "1" ]]; then
    echo "🌍 Opening browser..."
    # Use appropriate command based on OS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        open "http://localhost:${usage_port:-4001}"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        xdg-open "http://localhost:${usage_port:-4001}"
    fi &
fi

# Start miniserve in the doc directory
echo "📡 Serving documentation with miniserve..."
echo "Press Ctrl+C to stop the server"

miniserve doc --port "${usage_port:-4001}" --index "index.html"