Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  root "home#index"

  get "about", to: "about#index", as: "about_page"
  get "departures", to:"departures#index", as: "departures_page"

  get "departures-filter", to: "departures_filter#index", as: :departures_filter_page
  post "departures-filter", to: "departures_filter#search", as: :departures_filter_search
  get "set-journey", to: "departures_filter#set_journey", as: :departures_filter_set_journey


  get "train-route", to: "train_route#index", as: :train_route_page

  get 'login', to: "login#index", as: :login_page

end
