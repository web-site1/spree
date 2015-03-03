class CreateOldPages < ActiveRecord::Migration
  def change
    create_table :old_pages do |t|
      t.integer :taxon_id
      t.string :page
    end
  end
end
