# Gesttalt

A tool of expression on the Internet

## License

Gesttalt is licensed under the **Mozilla Public License Version 2.0 (MPL-2.0)**. This means you can freely use, modify, and distribute the software, including for commercial purposes. See the [LICENSE](LICENSE) file for details.

## About

Gesttalt is a tool of expression on the Internet that empowers you to collect, author, publish, and share your ideas in meaningful ways. Drawing inspiration from [Are.na](https://are.na), Gesttalt provides a creative space where your digital expressions can flourish and interconnect. Built by [Pedro Piñera](https://github.com/pepicrft), Gesttalt is designed to follow the standards and principles of the social web, ensuring your expressions remain open, accessible, and authentically yours.

The platform is designed to be **multi-tenant**, allowing multiple users to maintain their own spaces and collections within a single instance, or enabling organizations to run their own dedicated instances for their communities.

### Features

- **Express Freely**: Collect links, images, text, and files from across the web
- **Author Content**: Create and publish your own original content directly on the platform
- **Connect Meaningfully**: Weave relationships between ideas to create your own narrative
- **Share Openly**: Built on open web principles for authentic connection and expression
- **Experience Fluidly**: Fast, reliable, and scalable powered by Elixir and Phoenix
- **Visualize Creatively**: Shape and arrange your expressions in ways that resonate with you
- **Multi-tenant Architecture**: Support for multiple users and spaces within a single instance

### Hosted Instances

- **Official Instance**: Use the Tuist-maintained instance at [https://gesttalt.org](https://gesttalt.org)
- **Community Versions**: Find or host your own community-maintained instances

### Production Infrastructure

The official [gesttalt.org](https://gesttalt.org) instance runs on:

- **Server**: Managed by [Fly.io](https://fly.io) in Frankfurt, Germany
- **Database**: Managed by [Supabase](https://supabase.com) in Frankfurt, Germany
- **Email**: Delivered through [Plunk](https://useplunk.com/)

## Getting Started

To start your Gesttalt server:

  * Run `mise install` to install the project dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Deployment

Ready to share your digital garden with the world? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).
