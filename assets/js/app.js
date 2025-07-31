// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";
import "../css/app.css";

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;

// Theme management
// The theme automatically follows system preferences via CSS media queries,
// but you can also manually override it using the data-theme attribute.
// 
// Example usage:
// - Set light theme: window.setTheme('light')
// - Set dark theme: window.setTheme('dark')
// - Follow system: window.setTheme('auto')
// - Toggle theme: window.toggleTheme()

window.setTheme = function(theme) {
  if (theme === 'auto') {
    // Remove data-theme to follow system preference
    document.documentElement.removeAttribute('data-theme');
    localStorage.removeItem('theme');
  } else {
    // Set explicit theme
    document.documentElement.setAttribute('data-theme', theme);
    localStorage.setItem('theme', theme);
  }
};

window.toggleTheme = function() {
  const currentTheme = document.documentElement.getAttribute('data-theme');
  const systemPrefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
  
  if (!currentTheme) {
    // Currently following system, toggle to opposite of system preference
    window.setTheme(systemPrefersDark ? 'light' : 'dark');
  } else if (currentTheme === 'light') {
    window.setTheme('dark');
  } else {
    window.setTheme('light');
  }
};

// Load saved theme preference on page load
document.addEventListener('DOMContentLoaded', function() {
  const savedTheme = localStorage.getItem('theme');
  if (savedTheme) {
    document.documentElement.setAttribute('data-theme', savedTheme);
  }
  
  // Initialize heading anchors
  initializeHeadingAnchors();
});

// Heading anchor functionality
function initializeHeadingAnchors() {
  const headings = document.querySelectorAll('[data-heading="true"]');
  
  headings.forEach(function(heading) {
    const content = heading.querySelector('.gst-Heading_content');
    const anchor = heading.querySelector('.gst-Heading_anchor');
    
    if (content && anchor) {
      // Generate ID from text content
      const text = content.textContent || content.innerText;
      const id = generateHeadingId(text);
      
      // Set the heading ID
      heading.id = id;
      
      // Update anchor href
      anchor.href = '#' + id;
      
      // Add click handler for smooth scrolling
      anchor.addEventListener('click', function(e) {
        e.preventDefault();
        
        // Update URL without triggering page reload
        if (history.pushState) {
          history.pushState(null, null, '#' + id);
        } else {
          window.location.hash = '#' + id;
        }
        
        // Smooth scroll to element
        heading.scrollIntoView({
          behavior: 'smooth',
          block: 'start'
        });
      });
    }
  });
}

function generateHeadingId(text) {
  return text
    .toLowerCase()
    .trim()
    .replace(/[^\w\s-]/g, '') // Remove special characters except spaces and hyphens
    .replace(/[\s_-]+/g, '-') // Replace spaces and underscores with hyphens
    .replace(/^-+|-+$/g, ''); // Remove leading/trailing hyphens
}

// Re-initialize anchors for dynamically loaded content (LiveView)
window.addEventListener('phx:update', function() {
  initializeHeadingAnchors();
});
