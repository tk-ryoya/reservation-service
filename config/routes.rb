Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  namespace :admin do
    resources :reservations
    resources :users
    end

  root 'static_pages#top'
  get '/user_policy', to: 'static_pages#user_policy'
  get '/privacy_policy', to: 'static_pages#privacy_policy'

  get    '/login',  to: 'user_sessions#new'
  post   '/login',  to: 'user_sessions#create'
  delete '/logout', to: 'user_sessions#destroy'

  resources :users, only: %i[new create]
  resources :password_resets, only: %i[new create edit update]

  resources :reservations, only: %i[index new create show] do
    resources :first_interviews, only: %i[new create]
    resources :repeate_interviews, only: %i[new create]
  end
  delete '/reservations/:id', to: 'reservations#delete'

  resources :contacts, only: %i[new create]

  resource :profile, only: %i[show edit update]
end
