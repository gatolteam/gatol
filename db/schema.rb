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

ActiveRecord::Schema.define(version: 20151106004940) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "game_templates", force: :cascade do |t|
    t.string   "name",                    null: false
    t.string   "description", limit: 256, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: :cascade do |t|
    t.integer  "trainer_id"
    t.integer  "question_set_id"
    t.integer  "game_template_id"
    t.string   "name",             limit: 128, null: false
    t.string   "description",      limit: 256, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "games", ["game_template_id"], name: "index_games_on_game_template_id", using: :btree
  add_index "games", ["question_set_id"], name: "index_games_on_question_set_id", using: :btree
  add_index "games", ["trainer_id"], name: "index_games_on_trainer_id", using: :btree

  create_table "question_sets", force: :cascade do |t|
    t.string   "setname",    limit: 128, null: false
    t.integer  "trainer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "question_sets", ["trainer_id"], name: "index_question_sets_on_trainer_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.integer  "question_set_id"
    t.integer  "questionIdx",                 null: false
    t.string   "question",        limit: 256, null: false
    t.string   "answerCorrect",   limit: 256, null: false
    t.string   "answerWrong1",    limit: 256
    t.string   "answerWrong2",    limit: 256
    t.string   "answerWrong3",    limit: 256
    t.string   "answerWrong4",    limit: 256
    t.string   "answerWrong5",    limit: 256
    t.string   "answerWrong6",    limit: 256
    t.string   "answerWrong7",    limit: 256
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["question_set_id"], name: "index_questions_on_question_set_id", using: :btree

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

  add_index "students", ["auth_token"], name: "index_students_on_auth_token", unique: true, using: :btree
  add_index "students", ["email"], name: "index_students_on_email", unique: true, using: :btree
  add_index "students", ["reset_password_token"], name: "index_students_on_reset_password_token", unique: true, using: :btree

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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "auth_token",             default: ""
  end

  add_index "trainers", ["auth_token"], name: "index_trainers_on_auth_token", unique: true, using: :btree
  add_index "trainers", ["email"], name: "index_trainers_on_email", unique: true, using: :btree
  add_index "trainers", ["reset_password_token"], name: "index_trainers_on_reset_password_token", unique: true, using: :btree

  create_table "training_history", force: :cascade do |t|
    t.integer  "game_id"
    t.integer  "student_id"
    t.integer  "score",        null: false
    t.integer  "lastQuestion", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "training_history", ["game_id"], name: "index_training_history_on_game_id", using: :btree
  add_index "training_history", ["student_id"], name: "index_training_history_on_student_id", using: :btree

end
