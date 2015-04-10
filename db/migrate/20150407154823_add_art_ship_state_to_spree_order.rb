class AddArtShipStateToSpreeOrder < ActiveRecord::Migration

  def self.up
    add_column :spree_orders, :art_ship_state, :string, :limit =>25
    add_index :spree_orders, :art_ship_state
  end

  def self.down
    remove_column :spree_orders, :art_ship_state
  end

end
