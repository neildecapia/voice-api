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
    return
  end

  def newstate(event)
    state = event['ChannelState'].to_i
    return if state.in?([4, 5])  # ignore rings

    active_call = ActiveCall.where(unique_id: event['Uniqueid']).first
    return unless active_call

    active_call.update_attribute(:channel_state, state)
    return
  end

  def hangup(event)
    ActiveCall
      .where(unique_id: event['Uniqueid'])
    .delete_all
    return

  rescue ActiveRecord::StatementInvalid
  end

end

require 'clients/asterisk/event_handler'
Clients::Asterisk::EventHandler.send :include, ClientCallbacks
