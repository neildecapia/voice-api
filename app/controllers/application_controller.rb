class ApplicationController < ActionController::Base

  rescue_from AbstractController::ActionNotFound, with: :render_404
  rescue_from StandardError, with: :render_500

  # Called from config/routes.rb to render the "catchall route", i.e.,
  # routes really not meant to be handled. Should be catchable via
  # `ActionController::RoutingError`, but that error doesn't get to the
  # controller, so this hack is needed.
  def render_404(exception = nil)
    render(
      json: { errors: t(:not_found, scope: :controller) },
      status: :not_found
    )
  end


  protected

  def current_account
    doorkeeper_token.application
  end

  def current_account_id
    doorkeeper_token.application_id
  end
  helper_method :current_account_id

  def render_500(exception)
    render(
      json: { errors: t(:internal_server_error, scope: :controller) },
      status: :internal_server_error
    )
  end

end
