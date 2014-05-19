class CreateCalls < ActiveRecord::Migration
  def change
    create_table :calls do |t|
      t.string :unique_id, limit: 32
      t.references :account

      t.string :source, limit: 80
      t.string :source_channel, limit: 80
      t.string :caller_name, limit: 80
      t.string :destination, limit: 80
      t.string :destination_channel, limit: 80

      t.integer :sequence
      t.string :status, limit: 45
      t.timestamp :started_at
      t.timestamp :answered_at
      t.timestamp :ended_at

      t.integer :duration
      t.integer :billable_duration
      t.float :per_minute_rate
    end

    add_index :calls, :account_id
    add_index :calls, :sequence
    add_index :calls, :started_at
  end
end
