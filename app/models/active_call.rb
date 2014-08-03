class ActiveCall < ActiveRecord::Base

  CHANNEL_STATE_EVENTS = {
    0 => 'call_started',
    6 => 'call_connected'
  }

  class_attribute :client
  self.client = Api::Application.config.client

  belongs_to :sound

  after_commit :play_sound, on: :update
  after_commit :notify_account, on: [ :create, :update ]
  after_commit :hangup_call, on: :destroy

  attr_accessor :dtmf

  def answer
    client.answer(channel)
  end

  def bridge(other_active_call)
    client.bridge(channel, other_active_call.channel)
  end

  def record(options = {})
    client.record options.merge(channel: channel)

  rescue StandardError => e
    logger.error "Error recording active call: #{e.message}"
    logger.debug e.backtrace.join(?\n)
    raise
  end

  def as_json(options = {})
    attrs = {
      id: id,
      account_id: account_id,
      number: caller_id_number,
      caller_id: caller_id_name
    }
    attrs[:sound_id] = sound_id if sound.present?
    attrs
  end


  protected

  def play_sound
    return unless previous_changes['sound_id']

    if sound.present?
      client.play_sound(
        channel: channel,
        path: sound.path
      )

    else
      client.stop_sound(
        channel: channel
      )
    end

    return
  end

  def notify_account
    return if account_id.blank?

    event =
      if previous_changes['channel_state']
        CHANNEL_STATE_EVENTS[channel_state]

      elsif previous_changes['sound_id'].last.nil?
        'sound_playback_ended'
      end
    return unless event

    extra = {}
    extra[:dtmf] = dtmf if dtmf

    CallbackWorker.perform_async(
      account_id,
      event,
      self.class.name,
      id,
      extra
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
