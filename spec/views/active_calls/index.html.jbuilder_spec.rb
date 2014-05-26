require 'spec_helper'

describe "active_calls/index.json.jbuilder" do

  fixtures :active_calls

  it 'renders the list of calls' do
    active_call = active_calls(:user1)
    assign :active_calls, [active_call]
    render

    expect(rendered).to eq([ active_call.id ].to_json)
  end

end
