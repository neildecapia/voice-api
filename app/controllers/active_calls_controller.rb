class ActiveCallsController < ApplicationController

  doorkeeper_for :all, scopes: [ :voice ]

  before_action :set_active_call, only: [ :answer, :bridge, :destroy ]

  respond_to :json

  def index
    @active_calls = current_account.active_calls
      .order(:unique_id)
      .page(params[:page])
      .per(params[:per_page])
  end

  def answer
    @active_call.answer
    render nothing: true, status: :created
  end

  def bridge
    @other_call = current_account.active_calls.find(params[:active_call_id])
    @active_call.bridge @other_call
    render nothing: true, status: :created
  end

  def destroy
    @active_call.destroy
    render nothing: true, status: :no_content
  end


  protected

  def set_active_call
    @active_call = current_account.active_calls.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    render json: { errors: [ t('active_calls.not_found') ] }, status: :not_found
  end

end
