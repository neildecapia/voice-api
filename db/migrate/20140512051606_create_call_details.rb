class CreateCallDetails < ActiveRecord::Migration
  def change
    create_table :call_details do |t|
      t.string :unique_id, limit: 32
      t.references :account

      t.string :source, limit: 80
      t.string :source_channel, limit: 80
      t.string :caller_id, limit: 80
      t.string :destination, limit: 80
      t.string :destination_channel, limit: 80

      t.integer :sequence
      t.string :disposition, limit: 45
      t.timestamp :started_at
      t.timestamp :answered_at
      t.timestamp :ended_at
      t.integer :duration
      t.integer :billable_duration
    end
  end
end
