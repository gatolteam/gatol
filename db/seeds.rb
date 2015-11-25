# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#


# GAME TEMPLATES
templates = [
	{ name: 'Blobber', description: 'The bubble game that pops your brain out.'},
	{ name: 'Basket', description: 'Catch the balls corresponding to the correct answer!'},
	{ name: 'Shooter', description: 'Shoot away all the wrong answers!'}
]

gto = []

templates.each do |i|
	gto << GameTemplate.find_or_create_by(i)
end



# STUDENTS
students = [
	{ username: 'fredman', email: 'fred@man.com', password: '1234hello', password_confirmation: '1234hello'}, 
	{ username: 'sally', email: 'sally@joe.com', password: '1234hello', password_confirmation: '1234hello'}, 
	{ username: 'mo', email: 'mo@joe.com', password: '1234hello', password_confirmation: '1234hello'}
]

so = []
students.each do |i|
	#s = Student.new(i)
	#s.skip_confirmation!
	#s.save!
	s = Student.find_by(username: i[:username], email: i[:email]) || Student.create!(i)
	so << s
end



# TRAINERS
trainers = [
	{ username: 'boss', email: 'boss@man.com', password: '1234hello', password_confirmation: '1234hello'}, 
	{ username: 'frown', email: 'frown@joe.com', password: '1234hello', password_confirmation: '1234hello'}, 
]

to = []
trainers.each do |i|
	#t = Trainer.new(i)
	#t.skip_confirmation!
	#t.save!
	t = Trainer.find_by(username: i[:username], email: i[:email])|| Trainer.create!(i)
	to << t
end

# QUESTION SET
qs = QuestionSet.new(trainer_id: to[0].id)
qs.createSet("#{Rails.root}/spec/fixtures/files/demo1.csv")
qs.saveSet

# GAMES
games = [
	{ name: 'SuperBubbles', description: 'Pop til you drop!', trainer_id: to[0].id, question_set_id: qs.id, game_template_id: gto[0] }, 
	{ name: 'BerkeleyTime', description: 'Not late until 10 after', trainer_id: to[0].id, question_set_id: qs.id, game_template_id: gto[1] } 
] 

go = []
games.each do |i|
	g = Game.where(i).first_or_initialize
	g.save!
	go << g
end

# GAME ENROLLMENT
# Game 0 assigned to Students 0, 1, 2
# Game 1 assigned to Students 0, 2
enroll = [
	{ game_id: go[0].id, trainer_id: go[0].trainer_id, student_email: so[0].email, registered: true },
	{ game_id: go[0].id, trainer_id: go[0].trainer_id, student_email: so[1].email, registered: true },
	{ game_id: go[0].id, trainer_id: go[0].trainer_id, student_email: so[2].email, registered: true },
	{ game_id: go[1].id, trainer_id: go[1].trainer_id, student_email: so[0].email, registered: true },
	{ game_id: go[1].id, trainer_id: go[1].trainer_id, student_email: so[2].email, registered: true }
]
geo = []
enroll.each do |i|
	ge = GameEnrollment.where(i).first_or_initialize
	ge.save!
	geo << ge
end



# GAME INSTANCES

instances = [

	# GAME 0 DATA
	# STUDENT 0
	{ game_id: go[0].id, student_id: so[0].id, score: 50, lastQuestion: 2, active: false },
	{ game_id: go[0].id, student_id: so[0].id, score: 40, lastQuestion: 2, active: false },
	{ game_id: go[0].id, student_id: so[0].id, score: 30, lastQuestion: 2, active: false },
	{ game_id: go[0].id, student_id: so[0].id, score: 20, lastQuestion: 2, active: false },
	{ game_id: go[0].id, student_id: so[0].id, score: 15, lastQuestion: 2, active: false },
	{ game_id: go[0].id, student_id: so[0].id, score: 10, lastQuestion: 1, active: true },

	# STUDENT 1
	{ game_id: go[0].id, student_id: so[1].id, score: 90, lastQuestion: 2, active: false },
	{ game_id: go[0].id, student_id: so[1].id, score: 45, lastQuestion: 2, active: false },
	{ game_id: go[0].id, student_id: so[1].id, score: 25, lastQuestion: 2, active: false },
	{ game_id: go[0].id, student_id: so[1].id, score: 2, lastQuestion: 0, active: true },

	# STUDENT 2
	{ game_id: go[0].id, student_id: so[2].id, score: 80, lastQuestion: 2, active: false },
	{ game_id: go[0].id, student_id: so[2].id, score: 65, lastQuestion: 2, active: false },
	{ game_id: go[0].id, student_id: so[2].id, score: 35, lastQuestion: 2, active: false },
	{ game_id: go[0].id, student_id: so[2].id, score: 13, lastQuestion: 1, active: true },


	# GAME 1 DATA
	# STUDENT 0
	{ game_id: go[1].id, student_id: so[0].id, score: 20, lastQuestion: 2, active: false },
	{ game_id: go[1].id, student_id: so[0].id, score: 5, lastQuestion: 1, active: true },

	# STUDENT 1
	{ game_id: go[1].id, student_id: so[2].id, score: 15, lastQuestion: 2, active: false },
	{ game_id: go[1].id, student_id: so[2].id, score: 7, lastQuestion: 0, active: true }
]

io = []
instances.each do |i|
	gi = GameInstance.where(i).first_or_initialize
	gi.save!
	io << gi

end
