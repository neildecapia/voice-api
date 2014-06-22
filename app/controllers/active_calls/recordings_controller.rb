class ActiveCalls::RecordingsController < ApplicationController

  include ActiveCallScoped

  def create
    @recording = current_account.recordings.create! recording_params
    @message = t('.successful')

  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.message }, status: :unprocessable_entity
  end


  private

  def recording_params
    params.permit(
      :filename,
      :format,
      :time_limit
    )
      .merge(
        active_call: @active_call
      )
  end

end
