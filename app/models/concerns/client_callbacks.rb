module ClientCallbacks

  extend ActiveSupport::Concern

  def newchannel(event)
    ActiveCall.create(
      unique_id: event['Uniqueid'],
      channel: event['Channel']
    )

  rescue ActiveRecord::StatementInvalid
  end

  def new_account_code(event)
    ActiveCall
      .where(unique_id: event['Uniqueid'])
    .update_all(account_id: event['AccountCode'])
  end

  def hangup(event)
    ActiveCall
      .where(unique_id: event['Uniqueid'])
    .delete_all

  rescue ActiveRecord::StatementInvalid
  end

end

require 'clients/asterisk/event_handler'
Clients::Asterisk::EventHandler.send :include, ClientCallbacks
