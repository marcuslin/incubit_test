# frozen_string_literal: true

Rails.application.routes.draw do
  root 'registrations#new'

  get 'sign_up', to: 'registrations#new'
end
