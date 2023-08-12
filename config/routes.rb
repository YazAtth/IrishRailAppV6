Rails.application.routes.draw do

  root "home#index"

  get "about", to: "about#index", as: "about_page"
  get "departures", to:"departures#index", as: "departures_page"

  get "departures-filter", to: "departures_filter#index", as: :departures_filter_page
  post "departures-filter", to: "departures_filter#search", as: :departures_filter_search

  get "train-route", to: "train_route#index", as: :train_route_page

end
