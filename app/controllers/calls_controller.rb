class CallsController < ApplicationController

  doorkeeper_for :all

  respond_to :json

  def index
    @calls = current_account.calls
      .order(:started_at)
      .page(params[:page])
      .per(params[:per_page])
  end

  def create
    @call = current_account.calls.build call_params
    begin
      @call.save!

    rescue ActiveRecord::RecordNotSaved
    end
    @message = t('.successful')

  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.message }, status: :unprocessable_entity
  end


  private

  def call_params
    params.permit(
      :to,
      :caller_name,
      :time_limit,
      :per_minute_rate,
      :ring_timeout
    )
  end

end
