class AddSoundIdToActiveCalls < ActiveRecord::Migration
  def change
    add_column :active_calls, :sound_id, :integer
  end
end
