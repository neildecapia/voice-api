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
    @call = current_account.calls.create call_params

    respond_with @call do |format|
      format.json do
        if @call.valid?
          @message = t('.successful')

        else
          render json: { errors: @call.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
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
