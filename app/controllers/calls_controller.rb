class CallsController < ApplicationController

  doorkeeper_for :all

  respond_to :json

  def index
    @calls = current_account.call_details
      .page(params[:page])
      .per(params[:per_page])
  end

  def create
    @call = Call.create call_params

    respond_with(@call) do |format|
      format.json { render 'show' }
    end
  end


  private

  def call_params
    params
      .permit(:from, :to, :caller_name, :time_limit, :call_cost, :ring_timeout)
      .merge(account_id: current_account_id)
  end

  def current_account
    doorkeeper_token.application
  end

  def current_account_id
    doorkeeper_token.application_id
  end

end
