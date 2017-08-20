# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# FactoryGirl.create(:teacher, username: 'teacher')
# FactoryGirl.create(:student, username: 'student')
require 'faker'

# 20.times do 
# 	hw = Homework.create(user_id: 2, title: Faker::Hipster.sentence , content: Faker::Hipster.sentence(3))
# 	HomeworkAssignment.create(user_id: 1, homework_id: hw.id)
# 	HomeworkAssignment.create(user_id: 3, homework_id: hw.id)
# end

HomeworkAssignment.all.each do |hw|
	howmany = rand (20)
	hw.due_date = Faker::Date.between(60.days.ago, 1.year.from_now)
	hw.save
	howmany.times do 
		submission = Submission.create(:homework_assignment_id => hw.id, :score => rand(100), :scorer_id => 2, :content => Faker::Hacker.say_something_smart)
	end
end