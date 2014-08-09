Rails.application.routes.draw do
  devise_for :accounts,
    controllers: {
      registrations: 'accounts/registrations'
    }

  use_doorkeeper

  scope '/v1' do
    resources :calls, only: [ :index, :create ]
    resources :active_calls, only: [ :index, :destroy ] do
      post :answer, :bridge, on: :member
      scope module: 'active_calls' do
        resources :sounds, only: [ :create, :destroy ]
        resources :recordings, only: :create
      end
    end

    resources :sounds, only: [ :index, :create, :update, :destroy ]
  end

  # catchall route to render a "route not found" error
  match '*path',
    to: 'application#render_404',
    via: [:get, :post, :put, :delete]
end
