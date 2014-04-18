class CallsController < ApplicationController

  respond_to :json

  def create
    respond_with do |format|
      format.json { render 'show' }
    end
  end

end
