class CreateAllFromMerge < ActiveRecord::Migration
  def change
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
end
