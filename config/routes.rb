# frozen_string_literal: true

Rails.application.routes.draw do
  root 'registrations#new'

  get 'sign_up', to: 'registrations#new'
  post 'sign_up', to: 'registrations#create'

  resources :users, only: %i[edit update]
end
