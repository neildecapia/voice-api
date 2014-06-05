class CreateSounds < ActiveRecord::Migration
  def change
    create_table :sounds do |t|
      t.references :account
      t.string :name
      t.string :sound

      t.timestamps
    end

    add_index :sounds, :account_id
  end
end
