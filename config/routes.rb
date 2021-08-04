# frozen_string_literal: true

Rails.application.routes.draw do
  post '/login', to: 'users#login'
  post '/sign_up', to: 'users#sign_up'
end
