class CreateRecordings < ActiveRecord::Migration
  def change
    create_table :recordings do |t|
      t.references :account
      t.string :filename
      t.string :format

      t.timestamps
    end

    add_index :recordings, :account_id
  end
end
