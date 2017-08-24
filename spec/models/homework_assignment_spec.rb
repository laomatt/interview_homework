require 'rails_helper'
require 'database_cleaner'
require 'byebug'

RSpec.describe HomeworkAssignment, type: :model do
  before(:each) do 
		@student = FactoryGirl.create(:student, username: 'student')
		@student2 = FactoryGirl.create(:student, username: 'student2')
		@student3 = FactoryGirl.create(:student, username: 'student3')

		@teacher = FactoryGirl.create(:teacher, username: 'teacher')
		@teacher2 = FactoryGirl.create(:teacher, username: 'teacher2')
		@teacher3 = FactoryGirl.create(:teacher, username: 'teacher3')

		@homework = FactoryGirl.create(:homework, user_id: @teacher.id, content: "What was Khal Drogo's underpants size?")

		@homework_assignment = FactoryGirl.create(
			:homework_assignment,
		 	user_id: @student.id,
		 	homework_id: @homework.id,
		 	assigned_by: @teacher.id,
		 	due_date: Date.today + 3
		 	)

		@homework_assignment2 = FactoryGirl.create(
			:homework_assignment,
			user_id: @student2.id,
			homework_id: @homework.id,
		 	assigned_by: @teacher2.id,
			due_date: Date.today + 3
			)

		@homework_assignment_past_due = FactoryGirl.build(
			:homework_assignment,
			user_id: @student3.id,
			homework_id: @homework.id,
		 	assigned_by: @teacher3.id,
			due_date: Date.today - 3
			)

		@homework_assignment_past_due.skip_date_validation = true
		@homework_assignment_past_due.save

	end

	context 'validations' do
  	it "makes sure that teacher cannot assign the same homework to the same student more than once" do 
  		@homework_assignment_multiple = HomeworkAssignment.new(
						user_id: @student2.id,
						homework_id: @homework.id,
					 	assigned_by: @teacher2.id,
						due_date: Date.today + 3
  			)

  		expect(@homework_assignment_multiple.save).to eq false
  		expect(@homework_assignment_multiple.errors.full_messages).to eq ["User has already been taken"]
  	end

  	it "makes sure that teacher cannot assign over due assignment" do
  		@homework_assignment_overdue = HomeworkAssignment.new(
  					user_id: @student3.id,
						homework_id: @homework.id,
					 	assigned_by: @teacher2.id,
						due_date: Date.today - 3
  			)
  		expect(@homework_assignment_overdue.save).to eq false
  		expect(@homework_assignment_overdue.errors.full_messages).to eq ["Due date This date that is already past due", "User has already been taken"]
  	end

		it 'validates for user_id presence' do 
			 @homework_assignment_no_user = HomeworkAssignment.new(
						user_id: @student2.id,
						homework_id: @homework.id,
					 	assigned_by: @teacher2.id,
						due_date: Date.today + 3
  			)
  		expect(@homework_assignment_no_user.save).to eq false
  		expect(@homework_assignment_no_user.errors.full_messages).to eq ["User has already been taken"]
		end

	end

	context 'instance methods' do
		it 'makes sure that assigner method works and returns the assigner' do
			expect(@homework_assignment.assigner).to eq @teacher
		end

		it 'makes sure that past_due? method works' do
			expect(@homework_assignment_past_due.past_due?).to eq true
			expect(@homework_assignment.past_due?).to eq false
		end
		
	end


   after(:each) do 
    DatabaseCleaner.clean
  end
end
