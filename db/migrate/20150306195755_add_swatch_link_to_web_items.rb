class AddSwatchLinkToWebItems < ActiveRecord::Migration
  def change
    add_column :web_items, :swatch_alt, :string, :limit => 50
  end
end
