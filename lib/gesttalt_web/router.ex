defmodule GesttaltWeb.Router do
  use GesttaltWeb, :router

  import GesttaltWeb.UserAuth

  alias OpenApiSpex.Plug.PutApiSpec
  alias OpenApiSpex.Plug.RenderSpec
  alias Plug.Swoosh.MailboxPreview

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {GesttaltWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug GesttaltWeb.ThemeLoaderPlug
    plug GesttaltWeb.MetaTagsPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug PutApiSpec, module: GesttaltWeb.ApiSpec
  end

  pipeline :feeds do
    plug :accepts, ["rss", "atom", "xml"]
  end

  scope "/", GesttaltWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/explore", ExploreController, :index
    get "/debug", DebugController, :show
    get "/assets/theme.css", ThemeCSSController, :show
    post "/theme", ThemeController, :update
    get "/docs/api", ApiDocsController, :show

    # Legal pages
    get "/terms", LegalController, :terms
    get "/privacy", LegalController, :privacy
    get "/cookies", LegalController, :cookies
  end

  # Authenticated user routes
  scope "/", GesttaltWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/home", PageController, :home
  end

  # Admin routes
  scope "/admin", GesttaltWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/", AdminController, :index
  end

  # API routes
  scope "/api" do
    pipe_through :api
    get "/openapi", RenderSpec, []
  end

  scope "/api", GesttaltWeb do
    pipe_through :api

    # Health check endpoint
    get "/health", Api.HealthController, :check
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:gesttalt, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: GesttaltWeb.Telemetry
      forward "/mailbox", MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", GesttaltWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", GesttaltWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", GesttaltWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end

  # Blog feed routes (must come before dynamic routes)
  scope "/", GesttaltWeb do
    pipe_through [:feeds]

    get "/blog.xml", BlogController, :rss
    get "/blog/atom.xml", BlogController, :atom
  end

  # Blog routes
  scope "/", GesttaltWeb do
    pipe_through [:browser]

    get "/blog", BlogController, :index
    get "/blog/:id", BlogController, :show
  end

  # Changelog routes
  scope "/", GesttaltWeb do
    pipe_through [:browser]

    get "/changelog", ChangelogController, :index
    get "/changelog/:version", ChangelogController, :show
  end

  # User profile routes (must come last to avoid conflicts)
  scope "/", GesttaltWeb do
    pipe_through [:browser]

    get "/@:handle", UserProfileController, :show
  end

  # User management routes (authenticated users only)
  scope "/", GesttaltWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/@:handle/manage", UserProfileController, :manage
  end
end
