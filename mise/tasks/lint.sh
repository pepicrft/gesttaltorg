#!/usr/bin/env bash
# mise description="Run Credo linter on the codebase"

#USAGE flag "--fix" help="Run mix format to fix formatting issues"
#USAGE flag "--strict" help="Run Credo in strict mode"
#USAGE arg "[files...]" help="Specific files to lint"

set -euo pipefail

echo "🔍 Running linter..."

# Check if --fix flag is provided
if [[ "${usage_fix:-}" == "1" ]]; then
    echo "🔧 Running formatter to fix issues..."
    if [[ -n "${usage_files:-}" ]]; then
        mix format $usage_files
    else
        mix format
    fi
    echo "✅ Formatting complete"
fi

# Build Credo command
credo_cmd="mix credo"

# Add strict flag if provided
if [[ "${usage_strict:-}" == "1" ]]; then
    credo_cmd="$credo_cmd --strict"
fi

# Add specific files if provided
if [[ -n "${usage_files:-}" ]]; then
    credo_cmd="$credo_cmd $usage_files"
fi

# Run Credo
echo "🧐 Checking code quality with Credo..."
eval $credo_cmd