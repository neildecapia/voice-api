class CreateActiveCalls < ActiveRecord::Migration
  def change
    create_table :active_calls do |t|
      t.string :unique_id, limit: 32
      t.references :account
      t.string :channel, limit: 80
    end

    add_index :active_calls, :unique_id, unique: true
    add_index :active_calls, :account_id
    add_index :active_calls, :channel
  end
end
