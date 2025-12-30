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

ActiveRecord::Schema[8.0].define(version: 2025_12_30_062907) do
  create_table "plans", force: :cascade do |t|
    t.string "name", null: false
    t.integer "max_widgets"
    t.decimal "monthly_price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "question_options", force: :cascade do |t|
    t.integer "question_id", null: false
    t.string "option_text", null: false
    t.integer "position", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_question_options_on_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.integer "widget_id", null: false
    t.string "question_type", null: false
    t.text "question_text", null: false
    t.boolean "required", default: false
    t.integer "position", default: 0
    t.boolean "allow_other", default: false
    t.integer "min_value"
    t.integer "max_value"
    t.string "placeholder"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["widget_id"], name: "index_questions_on_widget_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "brand"
    t.string "status", default: "active"
    t.date "subscription_start_date"
    t.date "subscription_end_date"
    t.date "trial_end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "plan_id"
    t.index ["plan_id"], name: "index_subscriptions_on_plan_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "phone_number"
    t.string "full_name"
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "widgets", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.string "slug", null: false
    t.string "status", default: "draft"
    t.boolean "require_email", default: false
    t.date "start_date"
    t.date "end_date"
    t.integer "max_responses"
    t.integer "responses_count", default: 0
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "questions_count", default: 0
    t.index ["slug"], name: "index_widgets_on_slug", unique: true
    t.index ["user_id"], name: "index_widgets_on_user_id"
  end

  add_foreign_key "question_options", "questions"
  add_foreign_key "questions", "widgets"
  add_foreign_key "sessions", "users"
  add_foreign_key "subscriptions", "plans"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "widgets", "users"
end
