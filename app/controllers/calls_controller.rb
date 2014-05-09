class CallsController < ApplicationController

  doorkeeper_for :all

  respond_to :json

  def create
    @call = Call.create call_params

    respond_with(@call) do |format|
      format.json { render 'show' }
    end
  end


  private

  def call_params
    params.permit(:from, :to, :caller_name, :time_limit, :call_cost, :ring_timeout)
  end

end
