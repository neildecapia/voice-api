require 'spec_helper'

describe 'sounds/show.json.jbuilder' do

  fixtures :sounds

  it 'renders the sound' do
    assign :message, 'Sound is here'
    sound = sounds(:ding)
    assign :sound, sound
    render

    expect(rendered).to eq(
      {
        message: 'Sound is here',
        account_id: sound.account_id,
        id: sound.id,
        name: 'Ding',
        created_at: sound.created_at,
        updated_at: sound.updated_at
      }.to_json
    )
  end

end
