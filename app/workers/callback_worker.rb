class CallbackWorker

  include Sidekiq::Worker

  def perform(account_id, event, model_class, id)
    if account_id.blank? || event.blank? || model_class.blank? || id.blank?
      return 'OK'
    end

    account = Account.where(id: account_id).first
    unless account && account.callback_url.present?
      return 'OK'
    end

    klass = model_class.safe_constantize
    return 'OK' unless klass

    model = klass.where(id: id).first
    return 'OK' unless model

    Typhoeus.post(
      account.callback_url,
      body: {
        event: event,
        details: model
      }.to_json
    )

    return 'OK'
  end

end
