Rails.application.routes.draw do
  scope '/v1' do
    resources :calls, only: :create
  end
end
