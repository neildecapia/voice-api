require 'spec_helper'

describe 'sounds/index.json.jbuilder' do

  fixtures :sounds

  it 'renders the list of sounds' do
    sound = sounds(:ding)
    assign :sounds, [sound]
    render

    expect(rendered).to eq([
      {
        account_id: sound.account_id,
        name: 'Ding',
        created_at: sound.created_at,
        updated_at: sound.updated_at
      }
    ].to_json)
  end

end
