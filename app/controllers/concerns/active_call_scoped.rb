module ActiveCallScoped

  extend ActiveSupport::Concern

  included do
    before_action :set_active_call
  end


  protected

  def set_active_call
    @active_call = current_account.active_calls.find(params[:active_call_id])

  rescue ActiveRecord::RecordNotFound
    render(
      json: { errors: [ t('active_calls.not_found') ] },
      status: :not_found
    )
    false
  end

end
