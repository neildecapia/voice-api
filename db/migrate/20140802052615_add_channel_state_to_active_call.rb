class AddChannelStateToActiveCall < ActiveRecord::Migration
  def change
    add_column :active_calls, :channel_state, :integer
  end
end
