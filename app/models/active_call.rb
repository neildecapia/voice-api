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

  def record(options = {})
    client.record options.merge(channel: channel)

  rescue StandardError => e
    logger.error "Error recording active call: #{e.message}"
    logger.debug e.backtrace.join(?\n)
    raise
  end

  protected

  def hangup_call
    client.hangup channel

  rescue StandardError
  end

end
