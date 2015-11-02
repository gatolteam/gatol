class ResetAllTables < ActiveRecord::Migration
  def change
	 create_table "game_templates", force: true do |t|
	    t.string   "name",                    null: false
	    t.string   "description", limit: 256, null: false
	    t.datetime "created_at"
	    t.datetime "updated_at"
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
	    t.integer  "setid",                     null: false
	    t.string   "setname",       limit: 128, null: false
	    t.integer  "questionIdx",               null: false
	    t.string   "question",      limit: 256, null: false
	    t.string   "answerCorrect", limit: 256, null: false
	    t.string   "answerWrong1",  limit: 256
	    t.string   "answerWrong2",  limit: 256
	    t.string   "answerWrong3",  limit: 256
	    t.string   "answerWrong4",  limit: 256
	    t.string   "answerWrong5",  limit: 256
	    t.string   "answerWrong6",  limit: 256
	    t.string   "answerWrong7",  limit: 256
	    t.datetime "created_at"
	    t.datetime "updated_at"
	  end

	  create_table "training_history", force: true do |t|
	    t.integer  "gameid",       null: false
	    t.integer  "studentid",    null: false
	    t.integer  "score",        null: false
	    t.integer  "lastQuestion", null: false
	    t.datetime "created_at"
	    t.datetime "updated_at"
	  end
  end
end
