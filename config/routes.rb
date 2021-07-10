# frozen_string_literal: true

Rails.application.routes.draw do
  root 'sessions#new'

  get 'sign_up', to: 'registrations#new'
  post 'sign_up', to: 'registrations#create'

  get 'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create'
  delete 'sign_out', to: 'sessions#destroy'

  resources :users, only: %i[edit update]
end
