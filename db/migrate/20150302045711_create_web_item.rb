class CreateWebItem < ActiveRecord::Migration
  def change
    create_table :web_items do |t|
      t.string   "item",              limit: 50
      t.string   "cat",               limit: 50
      t.string   "subcat",            limit: 50
      t.string   "color",             limit: 50
      t.string   "title",             limit: 150
      t.text     "description",       limit: 16777215
      t.text     "top_description",   limit: 16777215
      t.string   "image_file",        limit: 150
      t.string   "swatch_image_file", limit: 150
      t.text     "keywords",          limit: 16777215
      t.string   "page"
      t.string   "error"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "web_items", ["item"], name: "index_web_items_on_item", using: :btree
  end
end
