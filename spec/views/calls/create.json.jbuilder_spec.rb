require 'spec_helper'

describe 'calls/create.json.jbuilder' do

  fixtures :calls

  it 'renders the call' do
    assign :message, 'Call initiated'
    call = calls(:answered)
    assign :call, call
    render

    expect(rendered).to eq(
      {
        account_id: call.account_id,
        message: 'Call initiated',
        to: nil,
        status: call.status,
        started_at: call.started_at,
        ended_at: call.ended_at,
        answered_at: call.answered_at,
        duration: call.billable_duration,
        per_minute_rate: call.per_minute_rate
      }.to_json
    )
  end

end
