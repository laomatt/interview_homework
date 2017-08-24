require 'rails_helper'
require 'database_cleaner'
require 'byebug'
DatabaseCleaner.strategy = :truncation

RSpec.describe Teacher::HomeworkAssignmentsController, type: :controller do
	before(:each) do 
    @student = FactoryGirl.create(:student, username: 'student')
    @student2 = FactoryGirl.create(:student, username: 'student2')
		@student3 = FactoryGirl.create(:student, username: 'student3')
		@teacher = FactoryGirl.create(:teacher, username: 'teacher')
		@teacher2 = FactoryGirl.create(:teacher, username: 'teacher2')
    @homework = FactoryGirl.create(:homework, user_id: @teacher.id)
    @homework2 = FactoryGirl.create(:homework, user_id: @teacher.id)
    @homework3 = FactoryGirl.create(:homework, user_id: @teacher2.id)

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
      due_date: Date.today + 3
      )

    @homework_assignment3 = FactoryGirl.create(
      :homework_assignment, 
      user_id: 5, 
      homework_id: @homework.id, 
      due_date: Date.today + 3
      )

    @homework_assignment4 = FactoryGirl.create(
      :homework_assignment, 
      user_id: 56, 
      homework_id: @homework.id, 
      due_date: Date.today + 3
      )

    @submission = FactoryGirl.create(
      :submission, 
      homework_assignment_id:@homework_assignment.id, 
      scorer_id:@teacher.id, 
      content:'this is an example answer'
      )
    
    session[:user_id] = @teacher.id
  end

	# student show not be able to be assigned same homework twice
	# POST create
  describe "POST create" do 
    it 'lets teacher assign if the teacher is valid' do 
      post :create, :teacher_id => @teacher.id, :assignment => { :user_id => @student3.id, :homework_id => @homework.id, :due_date => Date.today + 3}

      expect(flash[:update]).to eq "assigned"
    end

    it "makes sure that teachers cannot assign homework that doesn't belong to them" do 
      post :create, :teacher_id => @teacher.id, :assignment => { :user_id => @student.id, :homework_id => @homework3.id, :due_date => Date.today + 3}

      expect(flash[:error]).to eq "You cannot assign this homework"
    end


    it 'makes sure teacher cannot assign the same homework to a student more than once' do 
      post :create, :teacher_id => @teacher.id, :assignment => { :user_id => @student.id, :homework_id => @homework.id, :due_date => Date.today + 3}

      expect(flash[:error]).to eq "User has already been taken"
    end
  end

  # GET show
  describe "GET show" do 
    it "makes sure that the homework assignment shown is assigned by the teacher" do 
      get :show, :teacher_id => @teacher.id, :id => @homework_assignment2.id
      expect(flash[:error]).to eq "You cannot view this assignment"

      expect(response.redirect?).to eq true
    end

    it "displays a homework assignment" do 
      get :show, :teacher_id => @teacher.id, :id => @homework_assignment.id

      expect(response).to render_template('show')
    end
  end

  after(:each) do 
    DatabaseCleaner.clean
  end
end

