class ActiveCall < ActiveRecord::Base

  class_attribute :client
  self.client = Api::Application.config.client

  after_commit :hangup_call, on: :destroy

  def play_sound(sound)
    client.play_sound(
      channel: channel,
      path: sound.path
    )
  end

  def stop_sound(sound)
    client.stop_sound(
      channel: channel
    )
  end


  protected

  def hangup_call
    client.hangup channel

  rescue StandardError
  end

end
