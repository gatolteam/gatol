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

<<<<<<< HEAD
ActiveRecord::Schema.define(version: 20151024030312) do

  create_table "students", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "auth_token",             default: ""
  end

  add_index "students", ["auth_token"], name: "index_students_on_auth_token", unique: true
  add_index "students", ["email"], name: "index_students_on_email", unique: true
  add_index "students", ["reset_password_token"], name: "index_students_on_reset_password_token", unique: true

  create_table "trainers", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "auth_token",             default: ""
  end

  add_index "trainers", ["auth_token"], name: "index_trainers_on_auth_token", unique: true
  add_index "trainers", ["confirmation_token"], name: "index_trainers_on_confirmation_token", unique: true
  add_index "trainers", ["email"], name: "index_trainers_on_email", unique: true
  add_index "trainers", ["reset_password_token"], name: "index_trainers_on_reset_password_token", unique: true
=======
ActiveRecord::Schema.define(version: 20151024001801) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "game_templates", force: true do |t|
    t.string   "name",                    null: false
    t.string   "description", limit: 256, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "games", force: true do |t|
    t.integer  "trainerid",               null: false
    t.integer  "setid",                   null: false
    t.integer  "gametempid",              null: false
    t.string   "description", limit: 256, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "question_sets", force: true do |t|
    t.integer  "qid",                       null: false
    t.integer  "setid",                     null: false
    t.string   "setname",       limit: 128, null: false
    t.integer  "questionindex",             null: false
    t.string   "question",      limit: 256, null: false
    t.string   "answerCorrect", limit: 256, null: false
    t.string   "answerWrong1",  limit: 256
    t.string   "answerWrong2",  limit: 256
    t.string   "answerWrong3",  limit: 256
    t.string   "answerWrong4",  limit: 256
    t.string   "answerWrong5",  limit: 256
    t.string   "answerWrong6",  limit: 256
    t.string   "answerWrong7",  limit: 256
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "training_history", force: true do |t|
    t.integer  "gameid",     null: false
    t.integer  "studentid",  null: false
    t.integer  "score",      null: false
    t.integer  "lastq",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
>>>>>>> 363cca06f496995eca459807b6c55ac84ee83567

end
