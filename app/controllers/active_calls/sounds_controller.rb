module ActiveCalls

  class SoundsController < ApplicationController

    doorkeeper_for :all

    include ActiveCallScoped

    respond_to :json

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

    def set_sound
      @sound = current_account.sounds.find params[:sound_id]

    rescue ActiveRecord::RecordNotFound
      render(
        json: { errors: [ t('sounds.not_found') ] },
        status: :not_found
      )
      false
    end

  end

end
