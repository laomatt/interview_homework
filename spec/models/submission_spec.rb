require 'rails_helper'
require 'database_cleaner'
require 'byebug'

RSpec.describe Submission, type: :model do
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

		@homework_assignment = FactoryGirl.create(
			:homework_assignment, 
			user_id: @student.id, 
			homework_id: @homework.id, 
			due_date: Date.today + 3
			)

		@homework_assignment2 = FactoryGirl.create(
			:homework_assignment, 
			user_id: @student2.id, 
			homework_id: @homework.id, 
			due_date: Date.today + 3
			)

		@homework_assignment_overdue = FactoryGirl.build(
			:homework_assignment, 
			user_id: @student3.id, 
			homework_id: @homework.id, 
			due_date: Date.today - 3
			)
		
		@homework_assignment_overdue.skip_date_validation = true
		@homework_assignment_overdue.save

		@submission = Submission.new(
			:homework_assignment_id => @homework_assignment.id, 
			:content => 'Ask the dragon queen!'
			)
	end

	context 'validations' do
		it 'makes sure that a student cannot make a Submission past its assignment due date' do
			submission = Submission.new(:homework_assignment_id => @homework_assignment_overdue.id, :content => 'Ask the dragon queen!')
			expect(submission.save).to eq false
			expect(submission.errors.full_messages.any? {|e| e == "Created at This assignment is past due"}).to eq true
		end

		it 'prevents teacher from submitting an invalid score' do 
			@submission.update_attributes(:score => 130, :feedback => 'Dracarys!!')
			expect(@submission.update_attributes(:score => 130, :feedback => 'Dracarys!!')).to eq false
		end
	end

	context 'instance methods' do
		# proctor
		it 'a teacher can grade a submission and makes sure a submission returns the proctor name' do
			@submission.assign_attributes(:score => 20, :scorer_id =>@teacher.id, :feedback => 'Dracarys!!')
			expect(@submission.save).to eq true
			expect(@submission.proctor).to eq @teacher.username
		end


		# color_code
		it 'returns different colors for each grade' do
			color_arr = []
			[20,55,65,75,85,95].each do |score|
				@submission.assign_attributes(:score => score, :scorer_id =>@teacher.id, :feedback => 'Dracarys!!')
				color_arr << @submission.color_code
			end

			expect(color_arr == color_arr.uniq).to eq true
		end
	end

	after(:each) do 
    DatabaseCleaner.clean
  end
end
