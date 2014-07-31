class AddCallbackUrlToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :callback_url, :string
  end
end
