# frozen_string_literal: true

Rails.application.routes.draw do
  post 'auth/login', to: 'authentication#authenticate'
  namespace :api do
    namespace :v1 do
      post 'signup', to: 'users#create'
    end
  end
end
