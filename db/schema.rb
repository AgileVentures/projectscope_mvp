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

ActiveRecord::Schema.define(version: 20161201212334) do

  create_table "configs", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "metric_name"
    t.text     "encrypted_options"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "encrypted_options_iv"
  end

  add_index "configs", ["project_id"], name: "index_configs_on_project_id"

  create_table "metric_samples", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "metric_name"
    t.text     "encrypted_raw_data"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "encrypted_raw_data_iv"
    t.float    "score"
    t.text     "image"
  end

  add_index "metric_samples", ["project_id", "metric_name"], name: "index_metric_samples_on_project_id_and_metric_name"
  add_index "metric_samples", ["project_id"], name: "index_metric_samples_on_project_id"

  create_table "ownerships", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "project_id"
  end

  add_index "ownerships", ["project_id"], name: "index_ownerships_on_project_id"
  add_index "ownerships", ["user_id"], name: "index_ownerships_on_user_id"

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  add_index "projects", ["name"], name: "index_projects_on_name"

  create_table "projects_users", id: false, force: :cascade do |t|
    t.integer "project_id"
    t.integer "user_id"
  end

  add_index "projects_users", ["project_id"], name: "index_projects_users_on_project_id"
  add_index "projects_users", ["user_id"], name: "index_projects_users_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "provider_username",      default: "",        null: false
    t.string   "email",                  default: ""
    t.string   "encrypted_password",     default: "",        null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,         null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "role",                   default: "student", null: false
    t.text     "preferred_metrics"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["provider_username"], name: "index_users_on_provider_username", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "whitelists", force: :cascade do |t|
    t.string "username"
  end

  add_index "whitelists", ["username"], name: "index_whitelists_on_username"

end
