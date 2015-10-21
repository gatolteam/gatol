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

ActiveRecord::Schema.define(version: 20151021213012) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "game_templates", force: true do |t|
    t.integer  "hash",                    null: false
    t.string   "name",                    null: false
    t.string   "description", limit: 256, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "games", force: true do |t|
    t.integer  "gamehash",                null: false
    t.integer  "trainerhash",             null: false
    t.integer  "sethash",                 null: false
    t.integer  "gametempid",              null: false
    t.string   "description", limit: 256, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "question_sets", force: true do |t|
    t.integer  "qid",                       null: false
    t.integer  "qhash",                     null: false
    t.integer  "setid",                     null: false
    t.integer  "sethash",                   null: false
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
    t.integer  "gamehash",    null: false
    t.integer  "studenthash", null: false
    t.integer  "score",       null: false
    t.integer  "lastq",       null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
