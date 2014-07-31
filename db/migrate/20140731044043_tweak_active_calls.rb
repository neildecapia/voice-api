class TweakActiveCalls < ActiveRecord::Migration
  def change
    change_table :active_calls do |t|
      t.string :caller_id_number, limit: 80
      t.string :caller_id_name, limit: 80
    end
  end
end
