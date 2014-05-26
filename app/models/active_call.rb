class ActiveCall < ActiveRecord::Base

  class_attribute :client
  self.client = Api::Application.config.client

  after_commit :hangup_call, on: :destroy


  protected

  def hangup_call
    client.hangup channel

  rescue StandardError
  end

end
