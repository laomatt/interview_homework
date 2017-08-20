require 'rails_helper'
require 'database_cleaner'
require 'byebug'

RSpec.describe Homework, type: :model do
  before(:each) do 
		@student = FactoryGirl.create(:student, username: 'student')
		@student2 = FactoryGirl.create(:student, username: 'student2')
		@student3 = FactoryGirl.create(:student, username: 'student3')

		@teacher = FactoryGirl.create(:teacher, username: 'teacher')
		@teacher2 = FactoryGirl.create(:teacher, username: 'teacher2')
		@teacher3 = FactoryGirl.create(:teacher, username: 'teacher3')

		@homework = FactoryGirl.create(
			:homework,
			user_id: @teacher.id,
			content: "What was Khal Drogo's underpants size?"
		)

		@homework2 = FactoryGirl.create(
			:homework,
			user_id: @teacher.id,
			content: "Why does Batman glide?"
		)


		@homework_assignment = FactoryGirl.create(
			:homework_assignment, 
			user_id: @student.id, 
			homework_id: @homework.id, 
			due_date: Date.today + 3
			)

		@submission1 = FactoryGirl.create(
			:submission,
			homework_assignment_id: @homework_assignment.id,
			scorer_id: @teacher.id,
			score: 50,
			content: "Same size as Aqua mans",
			feedback: "Wrong universe"
			)

		@submission2 = FactoryGirl.create(
			:submission,
			homework_assignment_id: @homework_assignment.id,
			scorer_id: @teacher.id,
			score: 90,
			content: "XXL husky",
			feedback: "I think I saw that size at target"
		)


		# homework_assignment_id: integer, scorer_id: integer, content: text, score: float,

		@homework_assignment2 = FactoryGirl.create(
			:homework_assignment, 
			user_id: @student2.id, 
			homework_id: @homework.id, 
			due_date: Date.today + 3
			)

	end

	context 'instance method' do
		it 'returns the high score for the homework' do
			expect(@homework.high_score).to eq 90
			expect(@homework2.high_score).to eq nil
		end
	end

	after(:each) do 
    DatabaseCleaner.clean
  end
end
