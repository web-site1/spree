class AddCustNumberToSpreeUsers < ActiveRecord::Migration

  def self.up
    add_column :spree_users, :cust_number, :string, :limit =>12
    add_index :spree_users, :cust_number
  end

  def self.down
    remove_column :spree_users, :cust_number
  end

end
