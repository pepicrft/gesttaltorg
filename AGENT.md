# AGENT.md

This file provides guidance to AI agents (like Claude Code) when working with code in this repository.

## Project Overview

Gesttalt is a Phoenix Framework web application built with Elixir. It's a content organization platform that helps users capture, connect, and share ideas across the web, drawing inspiration from Are.na. It uses PostgreSQL as the database, Phoenix LiveView for real-time UI updates, and CSS with the EnduringCSS methodology for styling.

## AI Agent Capabilities

### Website Reference and Inspiration

When developing features for Gesttalt, the AI agent can use the Playwright MCP server to fetch and analyze websites for reference and raw inspiration. For example:
- **Are.na** (https://are.na) - The primary inspiration for Gesttalt's design and functionality
- Other content organization platforms for UI/UX patterns
- Design systems and style guides for visual inspiration

This capability allows the agent to understand the look, feel, and functionality of reference sites to better implement similar features in Gesttalt while maintaining its unique identity.

### Tidewave MCP Integration

Gesttalt includes Tidewave, an AI assistant that understands the web application through the Model Context Protocol (MCP). When running in development:

- **MCP Endpoint**: Available at `http://localhost:{PORT}/tidewave/mcp` (default PORT=4000)
- **MCP Proxy**: The `mcp-proxy-rust` tool is installed via Mise to connect STDIO-based MCP clients to Tidewave's HTTP/SSE endpoint
- **Usage**: Configure your AI editor (like Claude Desktop) to connect to the MCP endpoint for real-time application context

To use Tidewave with Claude Desktop:
```json
{
  "mcpServers": {
    "gesttalt": {
      "command": "mcp-proxy",
      "args": ["http://localhost:4000/tidewave/mcp"]
    }
  }
}
```

Note: Update the port in the args if running the server on a different port.

Note: The `mcp-proxy` command will be available after running `mise install`.

This gives the AI assistant direct access to understand the application's runtime state, database structure, and routes.

## Key Commands

### Development Setup
```bash
mix setup           # Install dependencies, create/migrate database, build assets
mix deps.get        # Install dependencies only
mise run install    # Run complete project setup using Mise
```

### Development Server
```bash
mix phx.server      # Start Phoenix server (visit localhost:4000)
iex -S mix phx.server  # Start server with interactive shell
PORT=3000 mix phx.server  # Start server on custom port
```

#### Port Configuration
The server port can be configured via the `PORT` environment variable:
```bash
PORT=5000 mix phx.server  # Start on port 5000
```

**Important for AI Agents:** When running the server to verify changes or test features, use a randomized port to avoid conflicts with any already running server:
```bash
PORT=$((4000 + RANDOM % 1000)) mix phx.server  # Random port between 4000-4999
```

**Stopping the Server:** When you need to stop a server, use the port number to find and kill the specific process:
```bash
# Find the process ID using the port
lsof -ti:4567  # Returns PID of process on port 4567

# Kill the server on a specific port
kill $(lsof -ti:4567)  # Kill process on port 4567

# Or as a one-liner with error handling
lsof -ti:4567 | xargs kill 2>/dev/null || true
```

**Never use** `pkill -f "beam.*phx.server"` as it will kill ALL Phoenix servers, not just yours!

### Database
```bash
mix ecto.create     # Create database
mix ecto.migrate    # Run migrations
mix ecto.reset      # Drop, recreate, and migrate database
mix ecto.setup      # Create, migrate, and seed database
```

### Testing
```bash
mix test            # Run all tests
mix test path/to/test.exs  # Run specific test file
mix test path/to/test.exs:42  # Run specific test at line 42
```

### Code Quality
```bash
mise run lint       # Run Credo linter
mise run lint --fix # Run formatter to fix issues
mise run lint --strict  # Run Credo in strict mode
mix format          # Format code with Elixir formatter + Quokka
mix format --check-formatted  # Check if code is formatted
```

### Assets
```bash
mix assets.build    # Build CSS and JS assets
mix assets.deploy   # Build and minify assets for production
```

## Development Environment

### Tool Management

All project dependencies should be managed through `mise.toml`:
- Add any new tools the project depends on to `mise.toml`
- Prefer using the `ubi:` syntax for universal binary installer backend when available
- Example: `"ubi:superfly/flyctl" = "0.3.161"`
- This ensures consistent tool versions across all development environments

### Automation Tasks

Automation should be implemented using [Mise file tasks](https://mise.jdx.dev/tasks/file-tasks.html):
- Create task scripts in `mise/tasks/` directory
- Keep CI pipelines lightweight by delegating to Mise tasks
- Use [Usage spec](https://usage.jdx.dev/) for flag parsing in scripts
- Example task with Usage spec:
  ```bash
  #!/usr/bin/env bash
  # mise description="Deploy the application"
  
  #USAGE flag "--dry-run" help="Run without making changes"
  #USAGE flag "--skip-migrations" help="Skip database migrations"
  #USAGE arg "<environment>" help="Target environment (staging or production)"
  
  # Access flags via $usage_dry_run (value: "1" if set)
  # Access arguments via $usage_environment
  if [[ "${usage_dry_run:-}" == "1" ]]; then
    echo "Running in dry-run mode..."
  fi
  ```

## Architecture Overview

### Styling Philosophy

Gesttalt follows an HTML-first approach to web design with CSS using the EnduringCSS methodology:

- **Semantic HTML**: Focus on using proper semantic elements (`<article>`, `<nav>`, `<section>`, etc.)
- **Text-First Design**: Content and readability are the primary concerns
- **Minimal Styling**: Clean, functional design inspired by [sourcehut.org](https://sourcehut.org/) and [ampcode.com](https://ampcode.com/how-to-build-an-agent)
- **Consistent Typography**: ALL text throughout the website uses the same font size (`--font-sizes-3`). This includes headers, body text, navigation, blog posts, changelogs, and all other content. Headers and titles are differentiated using font weight (`--font-weights-heading` vs `--font-weights-body`) rather than size. Never use larger font sizes for headers or titles
- **Custom Heading Components**: ALWAYS use the custom heading components (`<.h1>`, `<.h2>`, `<.h3>`, etc.) instead of plain HTML heading tags. These components include anchor links for navigation:
  ```heex
  <.h1 class="gst-Component_title">Page Title</.h1>
  <.h2 class="gst-Component_sectionTitle">Section Title</.h2>
  <.h3 class="gst-Component_subsectionTitle">Subsection Title</.h3>
  ```
- **EnduringCSS Methodology**: A CSS architecture designed for maintainability and scalability:
  - Namespace-based component architecture prevents style conflicts
  - Component namespaces: `.ns-Component {}` (e.g., `.gst-Home {}`)
  - Component modifiers: `.ns-Component--modifier {}` (e.g., `.gst-Header--compact {}`)
  - Component children: `.ns-Component_child {}` (e.g., `.gst-Home_title {}`)
  - State classes: `.is-state {}` (e.g., `.is-active {}`)
  - All CSS is written in `assets/css/app.css` without preprocessors
  - No utility-first frameworks - each component has purposeful, semantic styles

### Application Structure

- **lib/gesttalt/** - Core business logic and Ecto schemas
  - `application.ex` - OTP application supervisor tree configuration
  - `repo.ex` - Ecto repository for database interactions
  - `mailer.ex` - Email configuration using Swoosh

- **lib/gesttalt_web/** - Web layer (controllers, views, components)
  - `router.ex` - HTTP routing definitions with pipelines for browser and API requests
  - `endpoint.ex` - Phoenix endpoint configuration
  - `controllers/` - Request handlers
  - `components/` - Reusable UI components and layouts using Phoenix.Component

### Key Dependencies

- **Phoenix 1.7.21** - Web framework
- **Ecto/PostgreSQL** - Database layer
- **Phoenix LiveView** - Interactive, real-time UIs
- **Bandit** - HTTP server
- **Swoosh** - Email library

### Development Tools

In development mode, the following tools are available:
- **LiveDashboard** at `/dev/dashboard` - Real-time performance monitoring
- **Mailbox Preview** at `/dev/mailbox` - Preview sent emails

### Testing Approach

Tests use ExUnit and are organized by:
- `test/gesttalt_web/` - Web layer tests (controllers, views)
- `test/support/` - Test helpers and factories
  - `conn_case.ex` - Helper for controller/view tests
  - `data_case.ex` - Helper for schema/context tests

## Development Workflow

### Before Committing Code

Always verify your changes before committing:

1. **Compile the code** to check for syntax errors:
   ```bash
   mix compile
   ```

2. **Run tests** to ensure nothing is broken:
   ```bash
   mix test
   ```

3. **Format the code** using the project's formatter:
   ```bash
   mise run lint --fix
   ```

These steps help maintain code quality and consistency across the codebase. The CI pipeline will run these same checks, so running them locally first saves time and ensures your commits will pass CI.
