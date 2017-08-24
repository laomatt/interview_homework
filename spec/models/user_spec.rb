require 'rails_helper'
require 'database_cleaner'
require 'byebug'


RSpec.describe User, type: :model do
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
			due_date: Date.today + 3
			)

		@homework_assignment2 = FactoryGirl.create(
			:homework_assignment, 
			user_id: @student2.id, 
			homework_id: @homework.id, 
			due_date: Date.today + 3
			)
		
	end

	context 'class methods' do 
		it 'provides a list of all teachers' do
			User.teachers.each do |user|
				expect(user.role).to eq 'teacher'
			end
		end

		it 'provides a list of all students' do
			User.students.each do |user|
				expect(user.role).to eq 'student'
			end
		end

	end

	context 'validations' do
		it 'makes sure there is a username and role' do 
		end

		it 'make sure the username is uniq' do 
		end

	end

	context 'instance methods' do
		it "identifies if the user is a student or teacher" do
			User.all do |user|
				if user.role == 'teacher'
					expect(user.teacher?).to eq true
					expect(user.student?).to eq false
				else
					expect(user.teacher?).to eq false
					expect(user.student?).to eq true
				end
			end
		end

		it 'returns true if user has homework' do 
				expect(@teacher.has_homework?(@homework.id)).to eq true

		end

		it 'returns false if user does not have homework' do 
				expect(@teacher2.has_homework?(@homework.id)).to eq false
		end

		it 'provides appropriate assign button text based on homework' do
			expect(@student.assign_button(@homework.id)).to eq 'Assigned'
			expect(@student3.assign_button(@homework.id)).to eq 'Assign'
			expect(@teacher.assign_button(@homework.id)).to eq 'N/A'
		end
	end

	after(:each) do 
    DatabaseCleaner.clean
  end
end
