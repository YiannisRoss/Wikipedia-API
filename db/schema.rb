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

ActiveRecord::Schema.define(version: 2021_11_01_151424) do

  create_table "favoritings", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "wiki_entry_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_favoritings_on_user_id"
    t.index ["wiki_entry_id"], name: "index_favoritings_on_wiki_entry_id"
  end

  create_table "search_terms", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "body"
    t.integer "user_id"
    t.index ["user_id"], name: "index_search_terms_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean "admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wiki_entries", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "search_term_id", null: false
    t.string "title"
    t.integer "pageid"
    t.integer "wordcount"
    t.string "snippet"
    t.string "fullurl"
    t.index ["search_term_id"], name: "index_wiki_entries_on_search_term_id"
  end

  add_foreign_key "search_terms", "users"
  add_foreign_key "wiki_entries", "search_terms"
end
