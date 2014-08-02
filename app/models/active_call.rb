class ActiveCall < ActiveRecord::Base

  CHANNEL_STATE_EVENTS = {
    0 => 'call_started',
    6 => 'call_connected'
  }

  class_attribute :client
  self.client = Api::Application.config.client

  after_commit :notify_account, on: [ :create, :update ]
  after_commit :hangup_call, on: :destroy

  def answer
    client.answer(channel)
  end

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

  def as_json(options = {})
    # @note This assumes that the JSON representation of an ActiveCall
    #   is always an incoming call (hence the `from` key).
    {
      id: id,
      account_id: account_id,
      from: caller_id_number,
      caller_id: caller_id_name
    }
  end


  protected

  def notify_account
    return if account_id.blank?
    return unless event = CHANNEL_STATE_EVENTS[channel_state]

    CallbackWorker.perform_async(
      account_id,
      event,
      self.class.name,
      id
    )
    return
  end

  def hangup_call
    begin
      client.hangup channel

    rescue StandardError
    end

    return
  end

end
