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

ActiveRecord::Schema.define(version: 2018_11_13_052332) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "administrators", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_administrators_on_user_id"
  end

  create_table "cart_products", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "cart_id", null: false
    t.integer "quantity", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_cart_products_on_cart_id"
    t.index ["product_id"], name: "index_cart_products_on_product_id"
  end

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cash_on_deliveries", force: :cascade do |t|
    t.datetime "began_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cash_on_delivery_fees", force: :cascade do |t|
    t.bigint "cash_on_delivery_id", null: false
    t.integer "began_price", null: false
    t.integer "fee", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cash_on_delivery_id"], name: "index_cash_on_delivery_fees_on_cash_on_delivery_id"
  end

  create_table "delivery_fees", force: :cascade do |t|
    t.integer "per", null: false
    t.integer "fee", null: false
    t.datetime "began_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delivery_times", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.bigint "user_id", null: false
    t.bigint "delivery_time_id", null: false
    t.date "delivery_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_orders_on_cart_id"
    t.index ["delivery_time_id"], name: "index_orders_on_delivery_time_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "product_prices", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.integer "price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_prices_on_product_id"
  end

  create_table "product_publishes", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.boolean "published", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_publishes_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.string "image"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", default: 1, null: false
  end

  create_table "shipping_addresses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.string "address", null: false
    t.string "post", null: false
    t.string "tel", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_shipping_addresses_on_user_id"
  end

  create_table "taxes", force: :cascade do |t|
    t.decimal "rate", null: false
    t.datetime "began_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "administrators", "users"
  add_foreign_key "cart_products", "carts"
  add_foreign_key "cart_products", "products"
  add_foreign_key "cash_on_delivery_fees", "cash_on_deliveries"
  add_foreign_key "orders", "carts"
  add_foreign_key "orders", "delivery_times"
  add_foreign_key "orders", "users"
  add_foreign_key "product_prices", "products"
  add_foreign_key "product_publishes", "products"
  add_foreign_key "shipping_addresses", "users"
end
