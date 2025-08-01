# PLAN.md - Development Roadmap

This document outlines the next features and improvements to focus on for Gesttalt.

## 1. Toast Alerts System
Implement a toast notification system for user feedback on actions.

### Requirements
- Phoenix LiveView-based toast component
- Support for different types: success, error, info, warning
- Auto-dismiss with configurable duration
- Stack multiple toasts
- Smooth animations (appear/disappear)
- Follows EnduringCSS naming convention (`.gst-Toast`)
- Uses consistent font size (`--font-sizes-3`)

### Implementation Notes
- Create a `GesttaltWeb.ToastComponent` LiveComponent
- Add toast helpers to `core_components.ex`
- Use Phoenix PubSub for cross-component communication
- Position: top-right or bottom-right of viewport

## 2. Changelog Section Enhancement
The changelog is implemented but needs additional features.

### Requirements
- Add changelog link to footer under "Resources"
- Create changelog RSS/Atom feeds (`/changelog.xml`, `/changelog/atom.xml`)
- Add pagination for changelog entries
- Filter by category (feature, bugfix, security, etc.)
- Search functionality
- Changelog subscription/notification system

### Implementation Notes
- Extend `ChangelogController` with RSS/Atom actions
- Add feed discovery meta tags for changelog
- Create category filter UI component
- Consider using Phoenix LiveView for dynamic filtering

## 3. Fix Atom and RSS XML Generation
Current blog RSS/Atom feeds need proper XML generation.

### Issues to Fix
- Ensure proper XML escaping for special characters
- Add CDATA wrapping for HTML content
- Validate against RSS 2.0 and Atom 1.0 specs
- Add proper namespaces
- Include full post content, not just descriptions
- Fix date formatting (RFC-822 for RSS, ISO-8601 for Atom)

### Implementation Notes
- Create proper XML templates using EEx with XML content type
- Use `Phoenix.HTML.raw/1` carefully
- Add XML declaration and encoding
- Test with feed validators

## 4. ActivityPub Integration
Integrate Gesttalt with the Fediverse through ActivityPub protocol.

### Requirements
- User profiles as ActivityPub actors
- Micro posts as ActivityPub objects
- Follow/unfollow functionality
- Federation with Mastodon, Pleroma, etc.
- WebFinger support for user discovery
- Inbox/Outbox implementation

### Implementation Notes
- Research existing Elixir ActivityPub libraries (e.g., Pleroma's implementation)
- Start with read-only federation (others can follow)
- Implement actor endpoints (`/@username.json`)
- Add WebFinger endpoint (`/.well-known/webfinger`)
- Use GenServer for federation tasks
- Consider using Oban for background jobs

## 5. Micro Posts Feature
Start with the smallest unit of content - micro posts (like tweets/toots).

### Requirements
- 500 character limit posts
- Rich text support (bold, italic, links)
- Hashtag support with auto-linking
- @mentions with auto-completion
- Attach images (up to 4)
- Threading/reply support
- Edit within 5 minutes
- Delete own posts

### Implementation Notes
- Create `Gesttalt.Content.MicroPost` schema
- Use Phoenix LiveView for real-time posting
- Implement Markdown subset for formatting
- Store images using Arc or Waffle
- Create feed algorithm (chronological first, then explore recommendations)
- Add post composer component
- Consider draft saving

## Priority Order

1. **Micro Posts** - Core content feature, foundation for ActivityPub
2. **Toast Alerts** - Improves UX for all actions
3. **Fix RSS/Atom** - Quick win, improves existing features
4. **Changelog Enhancement** - Builds on existing implementation
5. **ActivityPub** - Complex but enables federation

## Technical Considerations

- Maintain consistent typography (`--font-sizes-3`)
- Follow EnduringCSS methodology for all new components
- Ensure all features work with existing theme system
- Write comprehensive tests for each feature
- Consider performance implications of federation
- Plan for moderation tools early

## Next Steps

1. Start with micro posts schema and basic CRUD
2. Implement toast system in parallel (different concern)
3. Fix RSS/Atom as a quick improvement
4. Enhance changelog based on user feedback
5. Research and plan ActivityPub implementation thoroughly