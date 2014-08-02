module ClientCallbacks

  extend ActiveSupport::Concern

  def newchannel(event)
    ActiveCall.create(
      account_id: event['Exten'],
      unique_id: event['Uniqueid'],
      channel: event['Channel'],
      channel_state: event['ChannelState'].to_i,
      caller_id_number: event['CallerIDNum'],
      caller_id_name: event['CallerIDName']
    )
    return

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
