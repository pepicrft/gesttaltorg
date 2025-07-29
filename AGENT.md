# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Gesttalt is a Phoenix Framework web application built with Elixir. It uses PostgreSQL as the database, Phoenix LiveView for real-time UI updates, and CSS with the EnduringCSS methodology for styling.

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
```

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
