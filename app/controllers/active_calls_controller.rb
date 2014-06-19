class ActiveCallsController < ApplicationController

  doorkeeper_for :all

  respond_to :json

  def index
    @active_calls = current_account.active_calls
      .order(:unique_id)
      .page(params[:page])
      .per(params[:per_page])
  end

  def destroy
    @active_call = current_account.active_calls.find(params[:id])
    @active_call.destroy
    render nothing: true, status: :no_content

  rescue ActiveRecord::RecordNotFound
    render json: { errors: [ t('active_calls.not_found') ] }, status: :not_found
  end

end
