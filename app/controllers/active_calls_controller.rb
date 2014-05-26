class ActiveCallsController < ApplicationController

  doorkeeper_for :all

  respond_to :json

  def index
    @active_calls = current_account.active_calls
      .order(:unique_id)
      .page(params[:page])
      .per(params[:per_page])
  end

end
