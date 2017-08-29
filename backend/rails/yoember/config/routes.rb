Rails.application.routes.draw do
  resources :invitations,defaults: {format: 'json'}

  root to: 'invitations#index', defaults: {format: 'json'}

  match "/404", to: "errors#not_found",             via: :all, defaults: {format: 'json'}
  match "/422", to: "errors#unacceptable",          via: :all, defaults: {format: 'json'}
  match "/500", to: "errors#internal_server_error", via: :all, defaults: {format: 'json'}
end
