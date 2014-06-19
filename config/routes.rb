Rails.application.routes.draw do
  scope '/v1' do
    use_doorkeeper do
      # @note Also skip `:authorizations` and `:applications` once
      #   Doorkeeper application management has been removed.
      skip_controllers :authorized_applications
    end

    resources :calls, only: [ :index, :create ]
    resources :active_calls, only: [ :index, :destroy ] do
      resources :sounds, only: [ :create, :destroy ], module: 'active_calls'
    end

    resources :sounds, only: [ :index, :create, :update, :destroy ]
  end
end
