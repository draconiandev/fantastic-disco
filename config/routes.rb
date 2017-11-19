# frozen_string_literal: true

Rails.application.routes.default_url_options = {
  host: 'rivalcorp.tk'
}

Rails.application.routes.draw do
  root 'home#index'

  devise_for :users
  resources :after_signup
end
