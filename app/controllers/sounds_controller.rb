class SoundsController < ApplicationController

  doorkeeper_for :all

  respond_to :json

  before_action :set_sound, only: [ :update, :destroy ]
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def index
    @sounds = current_account.sounds
      .order(:id)
      .page(params[:page])
      .per(params[:per_page])
  end

  def create
    @sound = current_account.sounds.create sound_params

    if @sound.persisted?
      @message = t('.successful')
      render 'show', status: :created

    else
      render_unprocessable_entity
    end
  end

  def update
    if @sound.update_attributes(sound_params)
      @message = t('.successful')
      render 'show'

    else
      render_unprocessable_entity
    end
  end

  def destroy
    @sound.destroy
    render nothing: true, status: :no_content
  end


  protected

  def set_sound
    @sound = current_account.sounds.find params[:id]
  end

  def sound_params
    params.permit(:name, :sound)
  end

  def render_not_found
    render json: { errors: [ t('sounds.not_found') ] }, status: :not_found
  end

  def render_unprocessable_entity
    render(
      json: { errors: @sound.errors.full_messages },
      status: :unprocessable_entity
    )
  end

end
