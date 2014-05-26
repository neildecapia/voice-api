Rails.application.routes.draw do
  scope '/v1' do
    use_doorkeeper do
      # @note Also skip `:authorizations` and `:applications` once
      #   Doorkeeper application management has been removed.
      skip_controllers :authorized_applications
    end

    resources :calls, only: [ :index, :create ]
    resources :active_calls, only: [ :index, :destroy ]
  end
end
