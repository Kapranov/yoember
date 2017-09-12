Rails.application.routes.draw do
  resources :libraries
  resources :invitations

  root to: 'invitations#index'

  match "/404", to: "errors#not_found",             via: :all
  match "/422", to: "errors#unacceptable",          via: :all
  match "/500", to: "errors#internal_server_error", via: :all
end
