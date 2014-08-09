class Accounts::RegistrationsController < Devise::RegistrationsController

  before_action :configure_permitted_params, only: [ :edit, :update ]


  protected

  def configure_permitted_params
    devise_parameter_sanitizer.for(:account_update) << :callback_url
  end

end
