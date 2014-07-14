Rails.application.routes.draw do
  scope '/v1' do
    use_doorkeeper do
      # @note Also skip `:authorizations` and `:applications` once
      #   Doorkeeper application management has been removed.
      skip_controllers :authorized_applications
    end

    resources :calls, only: [ :index, :create ]
    resources :active_calls, only: [ :index, :destroy ] do
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
