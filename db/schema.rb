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

ActiveRecord::Schema.define(version: 20140526161336) do

  create_table "active_calls", force: true do |t|
    t.string  "unique_id",  limit: 32
    t.integer "account_id"
    t.string  "channel",    limit: 80
  end

  add_index "active_calls", ["account_id"], name: "index_active_calls_on_account_id", using: :btree
  add_index "active_calls", ["channel"], name: "index_active_calls_on_channel", using: :btree
  add_index "active_calls", ["unique_id"], name: "index_active_calls_on_unique_id", unique: true, using: :btree

  create_table "calls", force: true do |t|
    t.string   "unique_id",           limit: 32
    t.integer  "account_id"
    t.string   "source",              limit: 80
    t.string   "source_channel",      limit: 80
    t.string   "caller_name",         limit: 80
    t.string   "destination",         limit: 80
    t.string   "destination_channel", limit: 80
    t.integer  "sequence"
    t.string   "status",              limit: 45
    t.datetime "started_at"
    t.datetime "answered_at"
    t.datetime "ended_at"
    t.integer  "duration"
    t.integer  "billable_duration"
    t.float    "per_minute_rate"
  end

  add_index "calls", ["account_id"], name: "index_calls_on_account_id", using: :btree
  add_index "calls", ["sequence"], name: "index_calls_on_sequence", using: :btree
  add_index "calls", ["started_at"], name: "index_calls_on_started_at", using: :btree

  create_table "oauth_access_grants", force: true do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: true do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: true do |t|
    t.string   "name",         null: false
    t.string   "uid",          null: false
    t.string   "secret",       null: false
    t.text     "redirect_uri", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["secret"], name: "index_oauth_applications_on_secret", unique: true, using: :btree
  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

end