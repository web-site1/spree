# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150407161340) do

  create_table "art_ship_states", force: :cascade do |t|
    t.string "art_state", limit: 25
  end

  add_index "art_ship_states", ["art_state"], name: "index_art_ship_states_on_art_state"

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",   limit: 4,   null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope",          limit: 255
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"

  create_table "old_pages", force: :cascade do |t|
    t.integer "taxon_id", limit: 4
    t.string  "page",     limit: 255
  end

  create_table "rc_pbs", force: :cascade do |t|
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

  create_table "rc_pbs_long_descs", force: :cascade do |t|
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
    t.string  "pbs_IQ_spool",      limit: 49
    t.string  "pbs_QQ_spool",      limit: 49
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

  create_table "spree_addresses", force: :cascade do |t|
    t.string   "firstname",         limit: 255
    t.string   "lastname",          limit: 255
    t.string   "address1",          limit: 255
    t.string   "address2",          limit: 255
    t.string   "city",              limit: 255
    t.string   "zipcode",           limit: 255
    t.string   "phone",             limit: 255
    t.string   "state_name",        limit: 255
    t.string   "alternative_phone", limit: 255
    t.string   "company",           limit: 255
    t.integer  "state_id",          limit: 4
    t.integer  "country_id",        limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_addresses", ["country_id"], name: "index_spree_addresses_on_country_id"
  add_index "spree_addresses", ["firstname"], name: "index_addresses_on_firstname"
  add_index "spree_addresses", ["lastname"], name: "index_addresses_on_lastname"
  add_index "spree_addresses", ["state_id"], name: "index_spree_addresses_on_state_id"

  create_table "spree_adjustments", force: :cascade do |t|
    t.integer  "source_id",       limit: 4
    t.string   "source_type",     limit: 255
    t.integer  "adjustable_id",   limit: 4
    t.string   "adjustable_type", limit: 255
    t.decimal  "amount",                      precision: 10, scale: 2
    t.string   "label",           limit: 255
    t.boolean  "mandatory"
    t.boolean  "eligible",                                             default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",           limit: 255
    t.integer  "order_id",        limit: 4
    t.boolean  "included",                                             default: false
  end

  add_index "spree_adjustments", ["adjustable_id", "adjustable_type"], name: "index_spree_adjustments_on_adjustable_id_and_adjustable_type"
  add_index "spree_adjustments", ["adjustable_id"], name: "index_adjustments_on_order_id"
  add_index "spree_adjustments", ["eligible"], name: "index_spree_adjustments_on_eligible"
  add_index "spree_adjustments", ["order_id"], name: "index_spree_adjustments_on_order_id"
  add_index "spree_adjustments", ["source_id", "source_type"], name: "index_spree_adjustments_on_source_id_and_source_type"

  create_table "spree_assets", force: :cascade do |t|
    t.integer  "viewable_id",             limit: 4
    t.string   "viewable_type",           limit: 255
    t.integer  "attachment_width",        limit: 4
    t.integer  "attachment_height",       limit: 4
    t.integer  "attachment_file_size",    limit: 4
    t.integer  "position",                limit: 4
    t.string   "attachment_content_type", limit: 255
    t.string   "attachment_file_name",    limit: 255
    t.string   "type",                    limit: 75
    t.datetime "attachment_updated_at"
    t.text     "alt",                     limit: 2147483647
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_assets", ["viewable_id"], name: "index_assets_on_viewable_id"
  add_index "spree_assets", ["viewable_type", "type"], name: "index_assets_on_viewable_type_and_type"

  create_table "spree_calculators", force: :cascade do |t|
    t.string   "type",            limit: 255
    t.integer  "calculable_id",   limit: 4
    t.string   "calculable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "preferences",     limit: 2147483647
  end

  add_index "spree_calculators", ["calculable_id", "calculable_type"], name: "index_spree_calculators_on_calculable_id_and_calculable_type"
  add_index "spree_calculators", ["id", "type"], name: "index_spree_calculators_on_id_and_type"

  create_table "spree_countries", force: :cascade do |t|
    t.string   "iso_name",        limit: 255
    t.string   "iso",             limit: 255
    t.string   "iso3",            limit: 255
    t.string   "name",            limit: 255
    t.integer  "numcode",         limit: 4
    t.boolean  "states_required",             default: false
    t.datetime "updated_at"
  end

  create_table "spree_credit_cards", force: :cascade do |t|
    t.string   "month",                       limit: 255
    t.string   "year",                        limit: 255
    t.string   "cc_type",                     limit: 255
    t.string   "last_digits",                 limit: 255
    t.integer  "address_id",                  limit: 4
    t.string   "gateway_customer_profile_id", limit: 255
    t.string   "gateway_payment_profile_id",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                        limit: 255
    t.integer  "user_id",                     limit: 4
    t.integer  "payment_method_id",           limit: 4
    t.boolean  "default",                                 default: false, null: false
  end

  add_index "spree_credit_cards", ["address_id"], name: "index_spree_credit_cards_on_address_id"
  add_index "spree_credit_cards", ["payment_method_id"], name: "index_spree_credit_cards_on_payment_method_id"
  add_index "spree_credit_cards", ["user_id"], name: "index_spree_credit_cards_on_user_id"

  create_table "spree_customer_returns", force: :cascade do |t|
    t.string   "number",            limit: 255
    t.integer  "stock_location_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_gateways", force: :cascade do |t|
    t.string   "type",        limit: 255
    t.string   "name",        limit: 255
    t.text     "description", limit: 2147483647
    t.boolean  "active",                         default: true
    t.string   "environment", limit: 255,        default: "development"
    t.string   "server",      limit: 255,        default: "test"
    t.boolean  "test_mode",                      default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "preferences", limit: 2147483647
  end

  add_index "spree_gateways", ["active"], name: "index_spree_gateways_on_active"
  add_index "spree_gateways", ["test_mode"], name: "index_spree_gateways_on_test_mode"

  create_table "spree_inventory_units", force: :cascade do |t|
    t.string   "state",        limit: 255
    t.integer  "variant_id",   limit: 4
    t.integer  "order_id",     limit: 4
    t.integer  "shipment_id",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "pending",                  default: true
    t.integer  "line_item_id", limit: 4
  end

  add_index "spree_inventory_units", ["line_item_id"], name: "index_spree_inventory_units_on_line_item_id"
  add_index "spree_inventory_units", ["order_id"], name: "index_inventory_units_on_order_id"
  add_index "spree_inventory_units", ["shipment_id"], name: "index_inventory_units_on_shipment_id"
  add_index "spree_inventory_units", ["variant_id"], name: "index_inventory_units_on_variant_id"

  create_table "spree_line_items", force: :cascade do |t|
    t.integer  "variant_id",           limit: 4
    t.integer  "order_id",             limit: 4
    t.integer  "quantity",             limit: 4,                                          null: false
    t.decimal  "price",                            precision: 10, scale: 2,               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "currency",             limit: 255
    t.decimal  "cost_price",                       precision: 10, scale: 2
    t.integer  "tax_category_id",      limit: 4
    t.decimal  "adjustment_total",                 precision: 10, scale: 2, default: 0.0
    t.decimal  "additional_tax_total",             precision: 10, scale: 2, default: 0.0
    t.decimal  "promo_total",                      precision: 10, scale: 2, default: 0.0
    t.decimal  "included_tax_total",               precision: 10, scale: 2, default: 0.0, null: false
    t.decimal  "pre_tax_amount",                   precision: 8,  scale: 2, default: 0.0
  end

  add_index "spree_line_items", ["order_id"], name: "index_spree_line_items_on_order_id"
  add_index "spree_line_items", ["tax_category_id"], name: "index_spree_line_items_on_tax_category_id"
  add_index "spree_line_items", ["variant_id"], name: "index_spree_line_items_on_variant_id"

  create_table "spree_log_entries", force: :cascade do |t|
    t.integer  "source_id",   limit: 4
    t.string   "source_type", limit: 255
    t.text     "details",     limit: 2147483647
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_log_entries", ["source_id", "source_type"], name: "index_spree_log_entries_on_source_id_and_source_type"

  create_table "spree_option_types", force: :cascade do |t|
    t.string   "name",         limit: 100
    t.string   "presentation", limit: 100
    t.integer  "position",     limit: 4,   default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_option_types", ["position"], name: "index_spree_option_types_on_position"

  create_table "spree_option_types_prototypes", id: false, force: :cascade do |t|
    t.integer "prototype_id",   limit: 4
    t.integer "option_type_id", limit: 4
  end

  create_table "spree_option_values", force: :cascade do |t|
    t.integer  "position",       limit: 4
    t.string   "name",           limit: 255
    t.string   "presentation",   limit: 255
    t.integer  "option_type_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_option_values", ["option_type_id"], name: "index_spree_option_values_on_option_type_id"
  add_index "spree_option_values", ["position"], name: "index_spree_option_values_on_position"

  create_table "spree_option_values_variants", id: false, force: :cascade do |t|
    t.integer "variant_id",      limit: 4
    t.integer "option_value_id", limit: 4
  end

  add_index "spree_option_values_variants", ["variant_id", "option_value_id"], name: "index_option_values_variants_on_variant_id_and_option_value_id"
  add_index "spree_option_values_variants", ["variant_id"], name: "index_spree_option_values_variants_on_variant_id"

  create_table "spree_orders", force: :cascade do |t|
    t.string   "number",                 limit: 32
    t.decimal  "item_total",                                precision: 10, scale: 2, default: 0.0,     null: false
    t.decimal  "total",                                     precision: 10, scale: 2, default: 0.0,     null: false
    t.string   "state",                  limit: 255
    t.decimal  "adjustment_total",                          precision: 10, scale: 2, default: 0.0,     null: false
    t.integer  "user_id",                limit: 4
    t.datetime "completed_at"
    t.integer  "bill_address_id",        limit: 4
    t.integer  "ship_address_id",        limit: 4
    t.decimal  "payment_total",                             precision: 10, scale: 2, default: 0.0
    t.integer  "shipping_method_id",     limit: 4
    t.string   "shipment_state",         limit: 255
    t.string   "payment_state",          limit: 255
    t.string   "email",                  limit: 255
    t.text     "special_instructions",   limit: 2147483647
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "currency",               limit: 255
    t.string   "last_ip_address",        limit: 255
    t.integer  "created_by_id",          limit: 4
    t.decimal  "shipment_total",                            precision: 10, scale: 2, default: 0.0,     null: false
    t.decimal  "additional_tax_total",                      precision: 10, scale: 2, default: 0.0
    t.decimal  "promo_total",                               precision: 10, scale: 2, default: 0.0
    t.string   "channel",                limit: 255,                                 default: "spree"
    t.decimal  "included_tax_total",                        precision: 10, scale: 2, default: 0.0,     null: false
    t.integer  "item_count",             limit: 4,                                   default: 0
    t.integer  "approver_id",            limit: 4
    t.datetime "approved_at"
    t.boolean  "confirmation_delivered",                                             default: false
    t.boolean  "considered_risky",                                                   default: false
    t.string   "guest_token",            limit: 255
    t.integer  "state_lock_version",     limit: 4,                                   default: 0,       null: false
    t.datetime "canceled_at"
    t.integer  "canceler_id",            limit: 4
    t.integer  "store_id",               limit: 4
    t.integer  "invoice_number",         limit: 4
    t.date     "invoice_date"
    t.string   "art_ship_state",         limit: 25
  end

  add_index "spree_orders", ["approver_id"], name: "index_spree_orders_on_approver_id"
  add_index "spree_orders", ["art_ship_state"], name: "index_spree_orders_on_art_ship_state"
  add_index "spree_orders", ["bill_address_id"], name: "index_spree_orders_on_bill_address_id"
  add_index "spree_orders", ["completed_at"], name: "index_spree_orders_on_completed_at"
  add_index "spree_orders", ["confirmation_delivered"], name: "index_spree_orders_on_confirmation_delivered"
  add_index "spree_orders", ["considered_risky"], name: "index_spree_orders_on_considered_risky"
  add_index "spree_orders", ["created_by_id"], name: "index_spree_orders_on_created_by_id"
  add_index "spree_orders", ["guest_token"], name: "index_spree_orders_on_guest_token"
  add_index "spree_orders", ["number"], name: "index_spree_orders_on_number"
  add_index "spree_orders", ["ship_address_id"], name: "index_spree_orders_on_ship_address_id"
  add_index "spree_orders", ["shipping_method_id"], name: "index_spree_orders_on_shipping_method_id"
  add_index "spree_orders", ["user_id", "created_by_id"], name: "index_spree_orders_on_user_id_and_created_by_id"
  add_index "spree_orders", ["user_id"], name: "index_spree_orders_on_user_id"

  create_table "spree_orders_promotions", id: false, force: :cascade do |t|
    t.integer "order_id",     limit: 4
    t.integer "promotion_id", limit: 4
  end

  add_index "spree_orders_promotions", ["order_id", "promotion_id"], name: "index_spree_orders_promotions_on_order_id_and_promotion_id"

  create_table "spree_payment_capture_events", force: :cascade do |t|
    t.decimal  "amount",               precision: 10, scale: 2, default: 0.0
    t.integer  "payment_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_payment_capture_events", ["payment_id"], name: "index_spree_payment_capture_events_on_payment_id"

  create_table "spree_payment_methods", force: :cascade do |t|
    t.string   "type",         limit: 255
    t.string   "name",         limit: 255
    t.text     "description",  limit: 2147483647
    t.boolean  "active",                          default: true
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "display_on",   limit: 255
    t.boolean  "auto_capture"
    t.text     "preferences",  limit: 2147483647
  end

  add_index "spree_payment_methods", ["id", "type"], name: "index_spree_payment_methods_on_id_and_type"

  create_table "spree_payments", force: :cascade do |t|
    t.decimal  "amount",                           precision: 10, scale: 2, default: 0.0, null: false
    t.integer  "order_id",             limit: 4
    t.integer  "source_id",            limit: 4
    t.string   "source_type",          limit: 255
    t.integer  "payment_method_id",    limit: 4
    t.string   "state",                limit: 255
    t.string   "response_code",        limit: 255
    t.string   "avs_response",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "number",               limit: 255
    t.string   "cvv_response_code",    limit: 255
    t.string   "cvv_response_message", limit: 255
  end

  add_index "spree_payments", ["order_id"], name: "index_spree_payments_on_order_id"
  add_index "spree_payments", ["payment_method_id"], name: "index_spree_payments_on_payment_method_id"
  add_index "spree_payments", ["source_id", "source_type"], name: "index_spree_payments_on_source_id_and_source_type"

  create_table "spree_preferences", force: :cascade do |t|
    t.text     "value",      limit: 2147483647
    t.string   "key",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_preferences", ["key"], name: "index_spree_preferences_on_key", unique: true

  create_table "spree_prices", force: :cascade do |t|
    t.integer  "variant_id", limit: 4,                            null: false
    t.decimal  "amount",                 precision: 10, scale: 2
    t.string   "currency",   limit: 255
    t.datetime "deleted_at"
  end

  add_index "spree_prices", ["deleted_at"], name: "index_spree_prices_on_deleted_at"
  add_index "spree_prices", ["variant_id", "currency"], name: "index_spree_prices_on_variant_id_and_currency"

  create_table "spree_product_option_types", force: :cascade do |t|
    t.integer  "position",       limit: 4
    t.integer  "product_id",     limit: 4
    t.integer  "option_type_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_product_option_types", ["option_type_id"], name: "index_spree_product_option_types_on_option_type_id"
  add_index "spree_product_option_types", ["position"], name: "index_spree_product_option_types_on_position"
  add_index "spree_product_option_types", ["product_id"], name: "index_spree_product_option_types_on_product_id"

  create_table "spree_product_properties", force: :cascade do |t|
    t.string   "value",       limit: 255
    t.integer  "product_id",  limit: 4
    t.integer  "property_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",    limit: 4,   default: 0
  end

  add_index "spree_product_properties", ["position"], name: "index_spree_product_properties_on_position"
  add_index "spree_product_properties", ["product_id"], name: "index_product_properties_on_product_id"
  add_index "spree_product_properties", ["property_id"], name: "index_spree_product_properties_on_property_id"

  create_table "spree_products", force: :cascade do |t|
    t.string   "name",                 limit: 255,        default: "",   null: false
    t.text     "description",          limit: 2147483647
    t.datetime "available_on"
    t.datetime "deleted_at"
    t.string   "slug",                 limit: 255
    t.text     "meta_description",     limit: 2147483647
    t.string   "meta_keywords",        limit: 255
    t.integer  "tax_category_id",      limit: 4
    t.integer  "shipping_category_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "promotionable",                           default: true
    t.string   "meta_title",           limit: 255
  end

  add_index "spree_products", ["available_on"], name: "index_spree_products_on_available_on"
  add_index "spree_products", ["deleted_at"], name: "index_spree_products_on_deleted_at"
  add_index "spree_products", ["name"], name: "index_spree_products_on_name"
  add_index "spree_products", ["shipping_category_id"], name: "index_spree_products_on_shipping_category_id"
  add_index "spree_products", ["slug"], name: "index_spree_products_on_slug", unique: true
  add_index "spree_products", ["tax_category_id"], name: "index_spree_products_on_tax_category_id"

  create_table "spree_products_promotion_rules", id: false, force: :cascade do |t|
    t.integer "product_id",        limit: 4
    t.integer "promotion_rule_id", limit: 4
  end

  add_index "spree_products_promotion_rules", ["product_id"], name: "index_products_promotion_rules_on_product_id"
  add_index "spree_products_promotion_rules", ["promotion_rule_id"], name: "index_products_promotion_rules_on_promotion_rule_id"

  create_table "spree_products_taxons", force: :cascade do |t|
    t.integer "product_id", limit: 4
    t.integer "taxon_id",   limit: 4
    t.integer "position",   limit: 4
  end

  add_index "spree_products_taxons", ["position"], name: "index_spree_products_taxons_on_position"
  add_index "spree_products_taxons", ["product_id"], name: "index_spree_products_taxons_on_product_id"
  add_index "spree_products_taxons", ["taxon_id"], name: "index_spree_products_taxons_on_taxon_id"

  create_table "spree_promotion_action_line_items", force: :cascade do |t|
    t.integer "promotion_action_id", limit: 4
    t.integer "variant_id",          limit: 4
    t.integer "quantity",            limit: 4, default: 1
  end

  add_index "spree_promotion_action_line_items", ["promotion_action_id"], name: "index_spree_promotion_action_line_items_on_promotion_action_id"
  add_index "spree_promotion_action_line_items", ["variant_id"], name: "index_spree_promotion_action_line_items_on_variant_id"

  create_table "spree_promotion_actions", force: :cascade do |t|
    t.integer  "promotion_id", limit: 4
    t.integer  "position",     limit: 4
    t.string   "type",         limit: 255
    t.datetime "deleted_at"
  end

  add_index "spree_promotion_actions", ["deleted_at"], name: "index_spree_promotion_actions_on_deleted_at"
  add_index "spree_promotion_actions", ["id", "type"], name: "index_spree_promotion_actions_on_id_and_type"
  add_index "spree_promotion_actions", ["promotion_id"], name: "index_spree_promotion_actions_on_promotion_id"

  create_table "spree_promotion_categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code",       limit: 255
  end

  create_table "spree_promotion_rules", force: :cascade do |t|
    t.integer  "promotion_id",     limit: 4
    t.integer  "user_id",          limit: 4
    t.integer  "product_group_id", limit: 4
    t.string   "type",             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code",             limit: 255
    t.text     "preferences",      limit: 2147483647
  end

  add_index "spree_promotion_rules", ["product_group_id"], name: "index_promotion_rules_on_product_group_id"
  add_index "spree_promotion_rules", ["promotion_id"], name: "index_spree_promotion_rules_on_promotion_id"
  add_index "spree_promotion_rules", ["user_id"], name: "index_promotion_rules_on_user_id"

  create_table "spree_promotion_rules_users", id: false, force: :cascade do |t|
    t.integer "user_id",           limit: 4
    t.integer "promotion_rule_id", limit: 4
  end

  add_index "spree_promotion_rules_users", ["promotion_rule_id"], name: "index_promotion_rules_users_on_promotion_rule_id"
  add_index "spree_promotion_rules_users", ["user_id"], name: "index_promotion_rules_users_on_user_id"

  create_table "spree_promotions", force: :cascade do |t|
    t.string   "description",           limit: 255
    t.datetime "expires_at"
    t.datetime "starts_at"
    t.string   "name",                  limit: 255
    t.string   "type",                  limit: 255
    t.integer  "usage_limit",           limit: 4
    t.string   "match_policy",          limit: 255, default: "all"
    t.string   "code",                  limit: 255
    t.boolean  "advertise",                         default: false
    t.string   "path",                  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "promotion_category_id", limit: 4
  end

  add_index "spree_promotions", ["advertise"], name: "index_spree_promotions_on_advertise"
  add_index "spree_promotions", ["code"], name: "index_spree_promotions_on_code"
  add_index "spree_promotions", ["expires_at"], name: "index_spree_promotions_on_expires_at"
  add_index "spree_promotions", ["id", "type"], name: "index_spree_promotions_on_id_and_type"
  add_index "spree_promotions", ["promotion_category_id"], name: "index_spree_promotions_on_promotion_category_id"
  add_index "spree_promotions", ["starts_at"], name: "index_spree_promotions_on_starts_at"

  create_table "spree_properties", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "presentation", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_properties_prototypes", id: false, force: :cascade do |t|
    t.integer "prototype_id", limit: 4
    t.integer "property_id",  limit: 4
  end

  create_table "spree_prototypes", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_refund_reasons", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.boolean  "active",                 default: true
    t.boolean  "mutable",                default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_refunds", force: :cascade do |t|
    t.integer  "payment_id",         limit: 4
    t.integer  "customer_return_id", limit: 4
    t.decimal  "amount",                         precision: 10, scale: 2, default: 0.0, null: false
    t.string   "transaction_id",     limit: 255
    t.datetime "created_at",                                                            null: false
    t.datetime "updated_at",                                                            null: false
  end

  create_table "spree_reimbursement_credits", force: :cascade do |t|
    t.decimal "amount",                       precision: 10, scale: 2, default: 0.0, null: false
    t.integer "reimbursement_id", limit: 4
    t.integer "creditable_id",    limit: 4
    t.string  "creditable_type",  limit: 255
  end

  create_table "spree_reimbursement_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.boolean  "active",                 default: true
    t.boolean  "mutable",                default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",       limit: 255
  end

  add_index "spree_reimbursement_types", ["type"], name: "index_spree_reimbursement_types_on_type"

  create_table "spree_reimbursements", force: :cascade do |t|
    t.string   "number",               limit: 255
    t.string   "reimbursement_status", limit: 255
    t.integer  "customer_return_id",   limit: 4
    t.integer  "order_id",             limit: 4
    t.decimal  "total",                            precision: 10, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_reimbursements", ["customer_return_id"], name: "index_spree_reimbursements_on_customer_return_id"
  add_index "spree_reimbursements", ["order_id"], name: "index_spree_reimbursements_on_order_id"

  create_table "spree_return_authorization_inventory_units", force: :cascade do |t|
    t.integer  "return_authorization_id", limit: 4
    t.integer  "inventory_unit_id",       limit: 4
    t.integer  "exchange_variant_id",     limit: 4
    t.datetime "received_at"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "spree_return_authorization_reasons", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.boolean  "active",                 default: true
    t.boolean  "mutable",                default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_return_authorizations", force: :cascade do |t|
    t.string   "number",                         limit: 255
    t.string   "state",                          limit: 255
    t.integer  "order_id",                       limit: 4
    t.text     "memo",                           limit: 2147483647
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stock_location_id",              limit: 4
    t.integer  "return_authorization_reason_id", limit: 4
  end

  add_index "spree_return_authorizations", ["return_authorization_reason_id"], name: "index_return_authorizations_on_return_authorization_reason_id"

  create_table "spree_return_items", force: :cascade do |t|
    t.integer  "return_authorization_id",         limit: 4
    t.integer  "inventory_unit_id",               limit: 4
    t.integer  "exchange_variant_id",             limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "pre_tax_amount",                                     precision: 12, scale: 4, default: 0.0,  null: false
    t.decimal  "included_tax_total",                                 precision: 12, scale: 4, default: 0.0,  null: false
    t.decimal  "additional_tax_total",                               precision: 12, scale: 4, default: 0.0,  null: false
    t.string   "reception_status",                limit: 255
    t.string   "acceptance_status",               limit: 255
    t.integer  "customer_return_id",              limit: 4
    t.integer  "reimbursement_id",                limit: 4
    t.integer  "exchange_inventory_unit_id",      limit: 4
    t.text     "acceptance_status_errors",        limit: 2147483647
    t.integer  "preferred_reimbursement_type_id", limit: 4
    t.integer  "override_reimbursement_type_id",  limit: 4
    t.boolean  "resellable",                                                                  default: true, null: false
  end

  add_index "spree_return_items", ["customer_return_id"], name: "index_return_items_on_customer_return_id"
  add_index "spree_return_items", ["exchange_inventory_unit_id"], name: "index_spree_return_items_on_exchange_inventory_unit_id"

  create_table "spree_roles", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "spree_roles_users", id: false, force: :cascade do |t|
    t.integer "role_id", limit: 4
    t.integer "user_id", limit: 4
  end

  add_index "spree_roles_users", ["role_id"], name: "index_spree_roles_users_on_role_id"
  add_index "spree_roles_users", ["user_id"], name: "index_spree_roles_users_on_user_id"

  create_table "spree_shipments", force: :cascade do |t|
    t.string   "tracking",             limit: 255
    t.string   "number",               limit: 255
    t.decimal  "cost",                             precision: 10, scale: 2, default: 0.0
    t.datetime "shipped_at"
    t.integer  "order_id",             limit: 4
    t.integer  "address_id",           limit: 4
    t.string   "state",                limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stock_location_id",    limit: 4
    t.decimal  "adjustment_total",                 precision: 10, scale: 2, default: 0.0
    t.decimal  "additional_tax_total",             precision: 10, scale: 2, default: 0.0
    t.decimal  "promo_total",                      precision: 10, scale: 2, default: 0.0
    t.decimal  "included_tax_total",               precision: 10, scale: 2, default: 0.0, null: false
    t.decimal  "pre_tax_amount",                   precision: 8,  scale: 2, default: 0.0
  end

  add_index "spree_shipments", ["address_id"], name: "index_spree_shipments_on_address_id"
  add_index "spree_shipments", ["number"], name: "index_shipments_on_number"
  add_index "spree_shipments", ["order_id"], name: "index_spree_shipments_on_order_id"
  add_index "spree_shipments", ["stock_location_id"], name: "index_spree_shipments_on_stock_location_id"

  create_table "spree_shipping_categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_shipping_method_categories", force: :cascade do |t|
    t.integer  "shipping_method_id",   limit: 4, null: false
    t.integer  "shipping_category_id", limit: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_shipping_method_categories", ["shipping_category_id", "shipping_method_id"], name: "unique_spree_shipping_method_categories", unique: true
  add_index "spree_shipping_method_categories", ["shipping_method_id"], name: "index_spree_shipping_method_categories_on_shipping_method_id"

  create_table "spree_shipping_methods", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "display_on",      limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tracking_url",    limit: 255
    t.string   "admin_name",      limit: 255
    t.integer  "tax_category_id", limit: 4
    t.string   "code",            limit: 255
  end

  add_index "spree_shipping_methods", ["deleted_at"], name: "index_spree_shipping_methods_on_deleted_at"
  add_index "spree_shipping_methods", ["tax_category_id"], name: "index_spree_shipping_methods_on_tax_category_id"

  create_table "spree_shipping_methods_zones", id: false, force: :cascade do |t|
    t.integer "shipping_method_id", limit: 4
    t.integer "zone_id",            limit: 4
  end

  create_table "spree_shipping_rates", force: :cascade do |t|
    t.integer  "shipment_id",        limit: 4
    t.integer  "shipping_method_id", limit: 4
    t.boolean  "selected",                                             default: false
    t.decimal  "cost",                         precision: 8, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tax_rate_id",        limit: 4
  end

  add_index "spree_shipping_rates", ["selected"], name: "index_spree_shipping_rates_on_selected"
  add_index "spree_shipping_rates", ["shipment_id", "shipping_method_id"], name: "spree_shipping_rates_join_index", unique: true
  add_index "spree_shipping_rates", ["tax_rate_id"], name: "index_spree_shipping_rates_on_tax_rate_id"

  create_table "spree_skrill_transactions", force: :cascade do |t|
    t.string   "email",          limit: 255
    t.real     "amount"
    t.string   "currency",       limit: 255
    t.integer  "transaction_id", limit: 4
    t.integer  "customer_id",    limit: 4
    t.string   "payment_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_state_changes", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.string   "previous_state", limit: 255
    t.integer  "stateful_id",    limit: 4
    t.integer  "user_id",        limit: 4
    t.string   "stateful_type",  limit: 255
    t.string   "next_state",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_state_changes", ["stateful_id", "stateful_type"], name: "index_spree_state_changes_on_stateful_id_and_stateful_type"
  add_index "spree_state_changes", ["user_id"], name: "index_spree_state_changes_on_user_id"

  create_table "spree_states", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "abbr",       limit: 255
    t.integer  "country_id", limit: 4
    t.datetime "updated_at"
  end

  add_index "spree_states", ["country_id"], name: "index_spree_states_on_country_id"

  create_table "spree_stock_items", force: :cascade do |t|
    t.integer  "stock_location_id", limit: 4
    t.integer  "variant_id",        limit: 4
    t.integer  "count_on_hand",     limit: 4, default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "backorderable",               default: false
    t.datetime "deleted_at"
  end

  add_index "spree_stock_items", ["backorderable"], name: "index_spree_stock_items_on_backorderable"
  add_index "spree_stock_items", ["deleted_at"], name: "index_spree_stock_items_on_deleted_at"
  add_index "spree_stock_items", ["stock_location_id", "variant_id"], name: "stock_item_by_loc_and_var_id"
  add_index "spree_stock_items", ["stock_location_id"], name: "index_spree_stock_items_on_stock_location_id"
  add_index "spree_stock_items", ["variant_id"], name: "index_spree_stock_items_on_variant_id"

  create_table "spree_stock_locations", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address1",               limit: 255
    t.string   "address2",               limit: 255
    t.string   "city",                   limit: 255
    t.integer  "state_id",               limit: 4
    t.string   "state_name",             limit: 255
    t.integer  "country_id",             limit: 4
    t.string   "zipcode",                limit: 255
    t.string   "phone",                  limit: 255
    t.boolean  "active",                             default: true
    t.boolean  "backorderable_default",              default: false
    t.boolean  "propagate_all_variants",             default: true
    t.string   "admin_name",             limit: 255
    t.boolean  "default",                            default: false, null: false
  end

  add_index "spree_stock_locations", ["active"], name: "index_spree_stock_locations_on_active"
  add_index "spree_stock_locations", ["backorderable_default"], name: "index_spree_stock_locations_on_backorderable_default"
  add_index "spree_stock_locations", ["country_id"], name: "index_spree_stock_locations_on_country_id"
  add_index "spree_stock_locations", ["propagate_all_variants"], name: "index_spree_stock_locations_on_propagate_all_variants"
  add_index "spree_stock_locations", ["state_id"], name: "index_spree_stock_locations_on_state_id"

  create_table "spree_stock_movements", force: :cascade do |t|
    t.integer  "stock_item_id",   limit: 4
    t.integer  "quantity",        limit: 4,   default: 0
    t.string   "action",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "originator_id",   limit: 4
    t.string   "originator_type", limit: 255
  end

  add_index "spree_stock_movements", ["stock_item_id"], name: "index_spree_stock_movements_on_stock_item_id"

  create_table "spree_stock_transfers", force: :cascade do |t|
    t.string   "type",                    limit: 255
    t.string   "reference",               limit: 255
    t.integer  "source_location_id",      limit: 4
    t.integer  "destination_location_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "number",                  limit: 255
  end

  add_index "spree_stock_transfers", ["destination_location_id"], name: "index_spree_stock_transfers_on_destination_location_id"
  add_index "spree_stock_transfers", ["number"], name: "index_spree_stock_transfers_on_number"
  add_index "spree_stock_transfers", ["source_location_id"], name: "index_spree_stock_transfers_on_source_location_id"

  create_table "spree_stores", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "url",               limit: 255
    t.text     "meta_description",  limit: 2147483647
    t.text     "meta_keywords",     limit: 2147483647
    t.string   "seo_title",         limit: 255
    t.string   "mail_from_address", limit: 255
    t.string   "default_currency",  limit: 255
    t.string   "code",              limit: 255
    t.boolean  "default",                              default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_stores", ["code"], name: "index_spree_stores_on_code"
  add_index "spree_stores", ["default"], name: "index_spree_stores_on_default"
  add_index "spree_stores", ["url"], name: "index_spree_stores_on_url"

  create_table "spree_tax_categories", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.boolean  "is_default",              default: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tax_code",    limit: 255
  end

  add_index "spree_tax_categories", ["deleted_at"], name: "index_spree_tax_categories_on_deleted_at"
  add_index "spree_tax_categories", ["is_default"], name: "index_spree_tax_categories_on_is_default"

  create_table "spree_tax_rates", force: :cascade do |t|
    t.decimal  "amount",                         precision: 8, scale: 5
    t.integer  "zone_id",            limit: 4
    t.integer  "tax_category_id",    limit: 4
    t.boolean  "included_in_price",                                      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",               limit: 255
    t.boolean  "show_rate_in_label",                                     default: true
    t.datetime "deleted_at"
  end

  add_index "spree_tax_rates", ["deleted_at"], name: "index_spree_tax_rates_on_deleted_at"
  add_index "spree_tax_rates", ["included_in_price"], name: "index_spree_tax_rates_on_included_in_price"
  add_index "spree_tax_rates", ["show_rate_in_label"], name: "index_spree_tax_rates_on_show_rate_in_label"
  add_index "spree_tax_rates", ["tax_category_id"], name: "index_spree_tax_rates_on_tax_category_id"
  add_index "spree_tax_rates", ["zone_id"], name: "index_spree_tax_rates_on_zone_id"

  create_table "spree_taxonomies", force: :cascade do |t|
    t.string   "name",       limit: 255,             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",   limit: 4,   default: 0
  end

  add_index "spree_taxonomies", ["position"], name: "index_spree_taxonomies_on_position"

  create_table "spree_taxons", force: :cascade do |t|
    t.integer  "parent_id",         limit: 4
    t.integer  "position",          limit: 4,          default: 0
    t.string   "name",              limit: 255,                    null: false
    t.string   "permalink",         limit: 255
    t.integer  "taxonomy_id",       limit: 4
    t.integer  "lft",               limit: 4
    t.integer  "rgt",               limit: 4
    t.string   "icon_file_name",    limit: 255
    t.string   "icon_content_type", limit: 255
    t.integer  "icon_file_size",    limit: 4
    t.datetime "icon_updated_at"
    t.text     "description",       limit: 2147483647
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "meta_title",        limit: 255
    t.string   "meta_description",  limit: 255
    t.string   "meta_keywords",     limit: 255
    t.integer  "depth",             limit: 4
  end

  add_index "spree_taxons", ["parent_id"], name: "index_taxons_on_parent_id"
  add_index "spree_taxons", ["permalink"], name: "index_taxons_on_permalink"
  add_index "spree_taxons", ["position"], name: "index_spree_taxons_on_position"
  add_index "spree_taxons", ["taxonomy_id"], name: "index_taxons_on_taxonomy_id"

  create_table "spree_taxons_promotion_rules", force: :cascade do |t|
    t.integer "taxon_id",          limit: 4
    t.integer "promotion_rule_id", limit: 4
  end

  add_index "spree_taxons_promotion_rules", ["promotion_rule_id"], name: "index_spree_taxons_promotion_rules_on_promotion_rule_id"
  add_index "spree_taxons_promotion_rules", ["taxon_id"], name: "index_spree_taxons_promotion_rules_on_taxon_id"

  create_table "spree_taxons_prototypes", force: :cascade do |t|
    t.integer "taxon_id",     limit: 4
    t.integer "prototype_id", limit: 4
  end

  add_index "spree_taxons_prototypes", ["prototype_id"], name: "index_spree_taxons_prototypes_on_prototype_id"
  add_index "spree_taxons_prototypes", ["taxon_id"], name: "index_spree_taxons_prototypes_on_taxon_id"

  create_table "spree_trackers", force: :cascade do |t|
    t.string   "analytics_id", limit: 255
    t.boolean  "active",                   default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_trackers", ["active"], name: "index_spree_trackers_on_active"

  create_table "spree_users", force: :cascade do |t|
    t.string   "encrypted_password",     limit: 128
    t.string   "password_salt",          limit: 128
    t.string   "email",                  limit: 255
    t.string   "remember_token",         limit: 255
    t.string   "persistence_token",      limit: 255
    t.string   "reset_password_token",   limit: 255
    t.string   "perishable_token",       limit: 255
    t.integer  "sign_in_count",          limit: 4,   default: 0, null: false
    t.integer  "failed_attempts",        limit: 4,   default: 0, null: false
    t.datetime "last_request_at"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "login",                  limit: 255
    t.integer  "ship_address_id",        limit: 4
    t.integer  "bill_address_id",        limit: 4
    t.string   "authentication_token",   limit: 255
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "spree_api_key",          limit: 48
    t.datetime "remember_created_at"
    t.datetime "deleted_at"
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "cust_number",            limit: 12
  end

  add_index "spree_users", ["cust_number"], name: "index_spree_users_on_cust_number"
  add_index "spree_users", ["deleted_at"], name: "index_spree_users_on_deleted_at"
  add_index "spree_users", ["email"], name: "email_idx_unique", unique: true
  add_index "spree_users", ["spree_api_key"], name: "index_spree_users_on_spree_api_key"

  create_table "spree_variants", force: :cascade do |t|
    t.string   "sku",               limit: 255,                          default: "",    null: false
    t.decimal  "weight",                        precision: 8,  scale: 2, default: 0.0
    t.decimal  "height",                        precision: 8,  scale: 2
    t.decimal  "width",                         precision: 8,  scale: 2
    t.decimal  "depth",                         precision: 8,  scale: 2
    t.datetime "deleted_at"
    t.boolean  "is_master",                                              default: false
    t.integer  "product_id",        limit: 4
    t.decimal  "cost_price",                    precision: 10, scale: 2
    t.string   "cost_currency",     limit: 255
    t.integer  "position",          limit: 4
    t.boolean  "track_inventory",                                        default: true
    t.integer  "tax_category_id",   limit: 4
    t.datetime "updated_at"
    t.integer  "stock_items_count", limit: 4,                            default: 0,     null: false
    t.string   "item_no",           limit: 15
  end

  add_index "spree_variants", ["deleted_at"], name: "index_spree_variants_on_deleted_at"
  add_index "spree_variants", ["is_master"], name: "index_spree_variants_on_is_master"
  add_index "spree_variants", ["item_no"], name: "index_spree_variants_on_item_no"
  add_index "spree_variants", ["position"], name: "index_spree_variants_on_position"
  add_index "spree_variants", ["product_id"], name: "index_spree_variants_on_product_id"
  add_index "spree_variants", ["sku"], name: "index_spree_variants_on_sku"
  add_index "spree_variants", ["tax_category_id"], name: "index_spree_variants_on_tax_category_id"
  add_index "spree_variants", ["track_inventory"], name: "index_spree_variants_on_track_inventory"

  create_table "spree_zone_members", force: :cascade do |t|
    t.integer  "zoneable_id",   limit: 4
    t.string   "zoneable_type", limit: 255
    t.integer  "zone_id",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_zone_members", ["zone_id"], name: "index_spree_zone_members_on_zone_id"
  add_index "spree_zone_members", ["zoneable_id", "zoneable_type"], name: "index_spree_zone_members_on_zoneable_id_and_zoneable_type"

  create_table "spree_zones", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.string   "description",        limit: 255
    t.boolean  "default_tax",                     default: false
    t.integer  "zone_members_count", limit: 4,    default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "kind",               limit: 4000
  end

  add_index "spree_zones", ["default_tax"], name: "index_spree_zones_on_default_tax"
  add_index "spree_zones", ["kind"], name: "index_spree_zones_on_kind"

  create_table "web_cats", force: :cascade do |t|
    t.string   "cat",             limit: 50
    t.string   "subcat",          limit: 50
    t.string   "title",           limit: 150
    t.text     "description",     limit: 2147483647
    t.text     "top_description", limit: 2147483647
    t.string   "image_file",      limit: 150
    t.text     "keywords",        limit: 2147483647
    t.string   "page",            limit: 255
    t.string   "error",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "web_items", force: :cascade do |t|
    t.string   "item",              limit: 50
    t.string   "cat",               limit: 50
    t.string   "subcat",            limit: 50
    t.string   "color",             limit: 50
    t.string   "title",             limit: 150
    t.text     "description",       limit: 2147483647
    t.text     "top_description",   limit: 2147483647
    t.string   "image_file",        limit: 150
    t.string   "swatch_image_file", limit: 150
    t.text     "keywords",          limit: 2147483647
    t.string   "page",              limit: 255
    t.string   "error",             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "swatch_alt",        limit: 50
  end

  add_index "web_items", ["item"], name: "index_web_items_on_item"

end
