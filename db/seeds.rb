require 'faker'

10.times do 
	user = User.new(role: "teacher", username: Faker::Simpsons.character)
	if !user.save
		puts user.errors.messages
		next
	end
end

100.times do
	user = User.new(role: "student", username: Faker::HarryPotter.character)
	if !user.save
		puts user.errors.messages
		next
	end
end

teach_ids = User.teachers.map { |e| e.id }
student_ids = User.students.map { |e| e.id }

20.times do 
	hw = Homework.create(user_id: 2, title: Faker::Hipster.sentence , content: Faker::Hipster.sentence(3))
	student_ids.shuffle.first(10).each do |st_id|
		hwa = HomeworkAssignment.create(user_id: st_id, homework_id: hw.id)
		howmany = rand (20)
		hwa.due_date = Faker::Date.between(60.days.ago, 1.year.from_now)
		hwa.save
		howmany.times do 
			submission = Submission.create(:homework_assignment_id => hwa.id, :score => rand(100), :scorer_id => teach_ids.sample, :content => Faker::Hacker.say_something_smart)
		end
	end
end

