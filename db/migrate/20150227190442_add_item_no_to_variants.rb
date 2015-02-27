class AddItemNoToVariants < ActiveRecord::Migration
  def self.up
    add_column :spree_variants, :item_no , :string , :limit => 15
    add_index :spree_variants, :item_no
  end

  def self.down
    remove_column :spree_variants, :item_no
  end


end
