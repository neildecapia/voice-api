module ActiveCalls

  class SoundsController < ApplicationController

    doorkeeper_for :all

    respond_to :json

    before_action :set_active_call
    before_action :set_sound

    def create
      @active_call.play_sound(@sound)
      @message = t('.successful')
      render :show, status: :created
    end

    def destroy
      @active_call.stop_sound @sound
      render nothing: true, status: :no_content
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

    def set_sound
      @sound = current_account.sounds.find params[:id]

    rescue ActiveRecord::RecordNotFound
      render(
        json: { errors: [ t('sounds.not_found') ] },
        status: :not_found
      )
      false
    end

  end

end
