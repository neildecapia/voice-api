require 'spec_helper'

describe 'calls/index.json.jbuilder' do

  fixtures :calls

  it 'renders the list of calls' do
    call = calls(:answered)
    assign :calls, [call]
    render

    expect(rendered).to eq([
        {
          account_id: call.account_id,
          from: call.from,
          caller_name: call.caller_name,
          to: call.to,
          status: call.status,
          started_at: call.started_at,
          ended_at: call.ended_at,
          answered_at: call.answered_at,
          duration: call.billable_duration,
          per_minute_rate: call.per_minute_rate
        }
      ].to_json
    )
  end

end
