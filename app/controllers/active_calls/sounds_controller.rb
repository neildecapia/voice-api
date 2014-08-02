module ActiveCalls

  class SoundsController < ApplicationController

    doorkeeper_for :all, scopes: [ :voice ]

    include ActiveCallScoped

    respond_to :json

    before_action :set_sound

    def create
      @active_call.sound = @sound
      @active_call.save

      @message = t('.successful')
      render :show, status: :created
    end

    def destroy
      @active_call.sound = nil
      @active_call.save

      render nothing: true, status: :no_content
    end


    protected

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
