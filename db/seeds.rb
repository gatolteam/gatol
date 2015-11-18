# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#


# GAME TEMPLATES
templates = [
	{ name: 'Blobber', description: 'The bubble game that pops your brain out.'},
	{ name: 'Run!', description: 'Run from the dogs and collect homework on the way to school!'},
	{ name: 'Tong', description: 'Like pong but with food.'}
]

gto = []

templates.each do |i|
	gto << GameTemplate.create(i)
end



# STUDENTS
students = [
	{ username: 'fredman', email: 'fred@man.com', password: '1234hello', password_confirmation: '1234hello'}, 
	{ username: 'sally', email: 'sally@joe.com', password: '1234hello', password_confirmation: '1234hello'}, 
]

so = []
students.each do |i|
	s = Student.new(i)
	s.skip_confirmation!
	s.save!
	so << s
end



# TRAINERS
trainers = [
	{ username: 'boss', email: 'boss@man.com', password: '1234hello', password_confirmation: '1234hello'}, 
	{ username: 'frown', email: 'frown@joe.com', password: '1234hello', password_confirmation: '1234hello'}, 
]

to = []
trainers.each do |i|
	t = Trainer.new(i)
	t.skip_confirmation!
	t.save!
	to << t
end

# QUESTION SET
qs = QuestionSet.new(trainer_id: to[0].id)
qs.createSet("#{Rails.root}/spec/fixtures/files/demo1.csv")

# GAMES
games = [
	{ name: 'SuperBubbles', description: 'Pop til you drop!', trainer_id: to[0].id, question_set_id: qs.id, game_template_id: gto[0] }, 
	{ name: 'BerkeleyTime', description: 'Not late until 10 after', trainer_id: to[0].id, question_set_id: qs.id, game_template_id: gto[1] } 
] 

go = []
games.each do |i|
	go << Game.create(i)
end

