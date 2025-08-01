# Content Architecture Design

## Database Schema Design

### Option 1: Single Table with Type Field (Recommended)

```elixir
# posts table
- id (uuid)
- user_id (uuid, FK)
- type (string) # "micro", "photo", "article", "code", "link", "video"
- content (text) # Main content, structure varies by type
- content_data (jsonb) # Type-specific data
- title (string, nullable) # For articles, code snippets
- slug (string, nullable) # For articles, SEO-friendly URLs
- visibility (string) # "public", "unlisted", "followers", "private"
- reply_to_id (uuid, nullable, FK) # For threading
- repost_of_id (uuid, nullable, FK) # For reposts/shares
- published_at (timestamp)
- edited_at (timestamp, nullable)
- deleted_at (timestamp, nullable) # Soft deletes
- metadata (jsonb) # Flexible metadata
- timestamps()

# content_data examples by type:
# micro: { "char_count": 500 }
# photo: { "images": [{"url": "...", "alt": "...", "width": 1200, "height": 800}] }
# article: { "excerpt": "...", "reading_time": 5, "toc": [...] }
# code: { "language": "elixir", "filename": "example.ex", "highlighting": true }
# link: { "url": "...", "title": "...", "description": "...", "image": "..." }
```

### Supporting Tables

```elixir
# post_tags table (many-to-many)
- post_id (uuid, FK)
- tag_id (uuid, FK)
- timestamps()

# tags table
- id (uuid)
- name (string, unique)
- slug (string, unique)
- usage_count (integer, default: 0)
- timestamps()

# post_mentions table
- post_id (uuid, FK)
- mentioned_user_id (uuid, FK)
- position (integer) # Position in content
- timestamps()

# post_attachments table (for additional files)
- id (uuid)
- post_id (uuid, FK)
- type (string) # "image", "document", "audio"
- url (string)
- metadata (jsonb) # Size, dimensions, duration, etc.
- position (integer) # Order
- timestamps()

# post_reactions table (likes, etc.)
- id (uuid)
- post_id (uuid, FK)
- user_id (uuid, FK)
- type (string) # "like", "bookmark", "..."
- timestamps()
- unique index on [post_id, user_id, type]

# post_collections table (user-created collections)
- id (uuid)
- post_id (uuid, FK)
- collection_id (uuid, FK)
- position (integer)
- added_at (timestamp)
- note (text, nullable)
```

## Why This Approach?

### Benefits:
1. **Single feed query**: Easy to query all content types in one go
2. **Consistent features**: All posts share comments, likes, tags, etc.
3. **Type flexibility**: Easy to add new content types
4. **Performance**: Single table with good indexes performs well
5. **ActivityPub ready**: Maps well to ActivityPub objects

### Type-Specific Behavior:

```elixir
defmodule Gesttalt.Content.Post do
  use Gesttalt.Schema
  
  @types ~w(micro photo article code link video)
  
  schema "posts" do
    belongs_to :user, Gesttalt.Accounts.User
    belongs_to :reply_to, __MODULE__
    belongs_to :repost_of, __MODULE__
    
    field :type, :string
    field :content, :string
    field :content_data, :map, default: %{}
    field :title, :string
    field :slug, :string
    field :visibility, :string, default: "public"
    field :published_at, :utc_datetime_usec
    field :edited_at, :utc_datetime_usec
    field :deleted_at, :utc_datetime_usec
    field :metadata, :map, default: %{}
    
    has_many :replies, __MODULE__, foreign_key: :reply_to_id
    has_many :reposts, __MODULE__, foreign_key: :repost_of_id
    has_many :attachments, Gesttalt.Content.PostAttachment
    has_many :reactions, Gesttalt.Content.PostReaction
    
    many_to_many :tags, Gesttalt.Content.Tag, 
      join_through: "post_tags",
      on_replace: :delete
    
    timestamps()
  end
  
  # Polymorphic behavior based on type
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:type, :content, :title, :visibility])
    |> validate_required([:type, :content])
    |> validate_inclusion(:type, @types)
    |> validate_by_type()
  end
  
  defp validate_by_type(changeset) do
    case get_field(changeset, :type) do
      "micro" -> validate_micro_post(changeset)
      "photo" -> validate_photo_post(changeset)
      "article" -> validate_article(changeset)
      "code" -> validate_code_snippet(changeset)
      _ -> changeset
    end
  end
  
  defp validate_micro_post(changeset) do
    changeset
    |> validate_length(:content, max: 500)
    |> put_content_data(:char_count, String.length(get_field(changeset, :content)))
  end
  
  defp validate_article(changeset) do
    changeset
    |> validate_required([:title])
    |> generate_slug()
    |> validate_length(:content, min: 100)
    |> calculate_reading_time()
    |> extract_table_of_contents()
  end
end
```

## Content Type Examples

### Micro Post
```elixir
%Post{
  type: "micro",
  content: "Just planted some new ideas in my digital garden! 🌱",
  content_data: %{
    "char_count" => 47
  }
}
```

### Photo Post
```elixir
%Post{
  type: "photo",
  content: "Check out this beautiful garden layout",
  content_data: %{
    "images" => [
      %{
        "url" => "/uploads/garden-1.jpg",
        "alt" => "Aerial view of garden beds",
        "width" => 1200,
        "height" => 800
      }
    ]
  }
}
```

### Article/Blog Post
```elixir
%Post{
  type: "article",
  title: "Growing Ideas: A Guide to Digital Gardening",
  slug: "growing-ideas-guide-digital-gardening",
  content: "Full markdown content here...",
  content_data: %{
    "excerpt" => "Learn how to cultivate...",
    "reading_time" => 5,
    "toc" => ["Introduction", "Getting Started", "Best Practices"]
  }
}
```

### Code Snippet
```elixir
%Post{
  type: "code",
  title: "Elixir Pattern Matching Example",
  content: "defmodule Garden do\n  def plant({:seed, type})...",
  content_data: %{
    "language" => "elixir",
    "filename" => "garden.ex",
    "highlighting" => true
  }
}
```

## Alternative: Separate Tables (Not Recommended)

```elixir
# posts table (base)
# micro_posts table (extends posts)
# articles table (extends posts)
# code_snippets table (extends posts)
```

This approach requires complex joins and makes feed queries difficult.

## Migration Order

1. Create posts table with all fields
2. Create tags and post_tags tables
3. Create post_attachments table
4. Create post_reactions table
5. Create post_mentions table
6. Add indexes for common queries:
   - posts.user_id + published_at (user timeline)
   - posts.type + published_at (type-specific feeds)
   - posts.visibility + published_at (public feed)
   - post_tags.tag_id + posts.published_at (tag feeds)

## Query Examples

```elixir
# User's mixed feed
Post
|> where([p], p.user_id == ^user_id)
|> where([p], is_nil(p.deleted_at))
|> order_by([p], desc: p.published_at)
|> preload([:user, :tags, :attachments])

# Type-specific feed
Post
|> where([p], p.type == "micro")
|> where([p], p.visibility == "public")
|> order_by([p], desc: p.published_at)

# Thread view
Post
|> where([p], p.id == ^post_id or p.reply_to_id == ^post_id)
|> order_by([p], asc: p.published_at)
```