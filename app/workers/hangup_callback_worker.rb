class HangupCallbackWorker

  include Sidekiq::Worker

  def perform(callback_url, call_hash)
    return 'OK' if callback_url.blank?

    Typhoeus.post(
      callback_url,
      body: {
        event: 'call_disconnected',
        call: call_hash
      }.to_json
    )

    return 'OK'
  end

end
