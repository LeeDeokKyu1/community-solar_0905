# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_08_30_101729) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "plan_id", null: false
    t.string "merchant_uid"
    t.string "imp_uid"
    t.integer "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0, null: false
    t.index ["imp_uid"], name: "index_orders_on_imp_uid"
    t.index ["merchant_uid"], name: "index_orders_on_merchant_uid"
    t.index ["plan_id"], name: "index_orders_on_plan_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "plans", force: :cascade do |t|
    t.integer "plan_type", null: false
    t.integer "capacity", default: 0
    t.integer "price"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["plan_type"], name: "index_plans_on_plan_type"
  end

  create_table "subscribes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "order_id"
    t.bigint "plan_id", null: false
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["end_at"], name: "index_subscribes_on_end_at"
    t.index ["order_id"], name: "index_subscribes_on_order_id"
    t.index ["plan_id"], name: "index_subscribes_on_plan_id"
    t.index ["start_at"], name: "index_subscribes_on_start_at"
    t.index ["user_id"], name: "index_subscribes_on_user_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "access_token", null: false
    t.datetime "last_accessed_at", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["access_token"], name: "index_tokens_on_access_token", unique: true
    t.index ["last_accessed_at"], name: "index_tokens_on_last_accessed_at"
    t.index ["user_id"], name: "index_tokens_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "login_provider", null: false
    t.string "login_user_id", null: false
    t.string "password_digest"
    t.string "householder_name", null: false
    t.string "name", null: false
    t.string "phone_number"
    t.string "apt_name", null: false
    t.string "building_number", null: false
    t.string "building_line_number", null: false
    t.boolean "active", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["active"], name: "index_users_on_active"
    t.index ["login_provider"], name: "index_users_on_login_provider"
    t.index ["login_user_id"], name: "index_users_on_login_user_id"
  end

end
