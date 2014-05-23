class ApplicationController < ActionController::Base

  protected

  def current_account
    doorkeeper_token.application
  end

  def current_account_id
    doorkeeper_token.application_id
  end

end
