class CreateRcPbs < ActiveRecord::Migration
  def change
    create_table :rc_pbs do |t|
      t.string  "brand",             limit: 20
      t.string  "item",              limit: 50
      t.string  "desc",              limit: 100
      t.decimal "rc_price",                      precision: 8,  scale: 2
      t.decimal "putup",                         precision: 8,  scale: 2
      t.string  "ws_cat",            limit: 50
      t.string  "ws_subcat",         limit: 50
      t.string  "ws_color",          limit: 50
      t.string  "pbs_item_no",       limit: 15
      t.string  "item_prod_cat",     limit: 5
      t.string  "item_prod_sub_cat", limit: 5
      t.string  "item_prime_vend",   limit: 6
      t.string  "offray_sku",        limit: 10
      t.string  "status",            limit: 25
      t.string  "new_pbs_item",      limit: 15
      t.string  "new_pbs_desc_1",    limit: 25
      t.string  "new_pbs_desc_2",    limit: 25
      t.string  "new_pbs_desc_3",    limit: 25
      t.string  "putup_pack",        limit: 20
      t.decimal "offcost",                       precision: 10, scale: 2
      t.decimal "cost2015",                      precision: 10, scale: 2
      t.decimal "QQ2015",                        precision: 10, scale: 2
      t.decimal "IQ2015",                        precision: 10, scale: 2
      t.decimal "pbs_prc_2",                     precision: 12, scale: 5
      t.decimal "pbs_prc_3",                     precision: 12, scale: 5
      t.decimal "pbs_IQ_spool",                  precision: 10, scale: 2
      t.decimal "pbs_QQ_spool",                  precision: 10, scale: 2
      t.decimal "IQ_diff",                       precision: 10, scale: 2
      t.decimal "IQmarkup",                      precision: 10, scale: 2
      t.decimal "QQmarkup",                      precision: 10, scale: 2
      t.decimal "newQQfact",                     precision: 4,  scale: 2
      t.decimal "newQQspool",                    precision: 10, scale: 2
      t.decimal "newIQfact",                     precision: 4,  scale: 2
      t.decimal "newIQspool",                    precision: 10, scale: 2
      t.decimal "IQpctup",                       precision: 4,  scale: 2
      t.string  "width",             limit: 10
    end

  end
end
