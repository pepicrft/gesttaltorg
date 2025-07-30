defmodule GesttaltWeb.ThemeToggle do
  use Phoenix.Component

  def theme_toggle(assigns) do
    ~H"""
    <div class="gst-ThemeToggle">
      <button type="button" class="gst-ThemeToggle_button" id="theme-toggle" phx-hook="ThemeToggle">
        <svg class="gst-ThemeToggle_icon" viewBox="0 0 24 24" aria-hidden="true">
          <%= if assigns[:theme] == "dark" do %>
            <!-- Sun icon for dark mode -->
            <path d="M12 17.5C9.5 17.5 7.5 15.5 7.5 13S9.5 8.5 12 8.5 16.5 10.5 16.5 13 14.5 17.5 12 17.5zM12 2v4M12 18v4M4.22 4.22l2.83 2.83M16.95 16.95l2.83 2.83M2 12h4M18 12h4M4.22 19.78l2.83-2.83M16.95 7.05l2.83-2.83" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" fill="none"/>
          <% else %>
            <!-- Moon icon for light mode -->
            <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" fill="none"/>
          <% end %>
        </svg>
        <span><%= if assigns[:theme] == "dark", do: "Light", else: "Dark" %></span>
      </button>
    </div>
    """
  end
end