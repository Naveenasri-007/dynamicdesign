# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_01_26_065336) do
  create_table "architects", charset: "utf8mb4", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "number"
    t.string "profile_photo", limit: 2000
    t.index ["email"], name: "index_architects_on_email", unique: true
    t.index ["reset_password_token"], name: "index_architects_on_reset_password_token", unique: true
  end

  create_table "bookings", charset: "utf8mb4", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "design_name"
    t.string "design_url"
    t.integer "expected_amount"
    t.integer "expected_months"
    t.text "message"
    t.string "status", default: "Pending"
    t.bigint "user_id", null: false
    t.bigint "architect_id", null: false
    t.bigint "design_id", null: false
    t.index ["architect_id"], name: "index_bookings_on_architect_id"
    t.index ["design_id"], name: "index_bookings_on_design_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "comments", charset: "utf8mb4", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id", null: false
    t.bigint "design_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["design_id"], name: "index_comments_on_design_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "designs", charset: "utf8mb4", force: :cascade do |t|
    t.string "design_name", null: false
    t.string "style", null: false
    t.decimal "price_per_sqft", precision: 10, null: false
    t.integer "square_feet", null: false
    t.string "category", null: false
    t.string "floorplan", null: false
    t.string "time_required", null: false
    t.string "bio", null: false
    t.text "brief", null: false
    t.bigint "architect_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "design_url", limit: 2000, default: "https://icon-library.com/images/no-picture-available-icon/no-picture-available-icon-1.jpg"
    t.index ["architect_id"], name: "index_designs_on_architect_id"
  end

  create_table "likes", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "design_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["design_id"], name: "index_likes_on_designs_id"
    t.index ["user_id"], name: "index_likes_on_users_id"
  end

  create_table "ratings", charset: "utf8mb4", force: :cascade do |t|
    t.integer "value"
    t.bigint "design_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["design_id"], name: "index_ratings_on_design_id"
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "phone_number"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bookings", "architects"
  add_foreign_key "bookings", "designs"
  add_foreign_key "bookings", "users"
  add_foreign_key "comments", "designs"
  add_foreign_key "comments", "users"
  add_foreign_key "designs", "architects"
  add_foreign_key "likes", "designs"
  add_foreign_key "likes", "users"
  add_foreign_key "ratings", "designs"
  add_foreign_key "ratings", "users"
end
