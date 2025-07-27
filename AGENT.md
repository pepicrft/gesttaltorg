# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Gesttalt is a Phoenix Framework web application built with Elixir. It uses PostgreSQL as the database, Phoenix LiveView for real-time UI updates, and Tailwind CSS for styling.

## Key Commands

### Development Setup
```bash
mix setup           # Install dependencies, create/migrate database, build assets
mix deps.get        # Install dependencies only
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

### Assets
```bash
mix assets.build    # Build CSS and JS assets
mix assets.deploy   # Build and minify assets for production
```

## Architecture Overview

### Styling Philosophy

Gesttalt follows an HTML-first approach to web design:

- **Semantic HTML**: Focus on using proper semantic elements (`<article>`, `<nav>`, `<section>`, etc.)
- **Text-First Design**: Content and readability are the primary concerns
- **Minimal Styling**: Clean, functional design inspired by [sourcehut.org](https://sourcehut.org/) and [ampcode.com](https://ampcode.com/how-to-build-an-agent)
- **EnduringCSS Convention**: Use namespace-based selectors following the EnduringCSS methodology:
  - Component namespaces: `.ns-Component {}`
  - Component modifiers: `.ns-Component--modifier {}`
  - Component children: `.ns-Component_child {}`
  - State classes: `.is-state {}`
  - Example: `.gst-Header {}`, `.gst-Header--compact {}`, `.gst-Header_logo {}`

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
