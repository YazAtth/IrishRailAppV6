// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"



window.navbarToggle = function() {

    // alert("toggled");

    const navbar = document.getElementById("navbar")

    if (navbar.className === "navbar dropdown-hidden") {
        navbar.className = "navbar dropdown-active"
    } else {
        navbar.className = "navbar dropdown-hidden"
    }

}