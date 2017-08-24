require 'rails_helper'
require 'database_cleaner'
require 'byebug'
DatabaseCleaner.strategy = :truncation

RSpec.describe Teacher::HomeworkController, type: :controller do

  before(:each) do 
    @student = FactoryGirl.create(:student, username: 'student')
		@student2 = FactoryGirl.create(:student, username: 'student2')
		@teacher = FactoryGirl.create(:teacher, username: 'teacher')
		@teacher2 = FactoryGirl.create(:teacher, username: 'teacher2')
    @homework = FactoryGirl.create(:homework, user_id: @teacher.id)
    @homework2 = FactoryGirl.create(:homework, user_id: @teacher.id)
    @homework3 = FactoryGirl.create(:homework, user_id: @teacher.id)

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

  describe "GET index" do
    it "lists all teachers Homeworks" do
      get :index, :teacher_id => @teacher.id
      assigns(:homeworks).all.each do |hwa|
        hwa.should be_kind_of(Homework)
        expect(hwa.user_id).to eq @teacher.id
      end

      expect(response).to render_template('index')
    end

    it "Should redirect user if the homework list shown does not belong to the user" do 
      get :index, :teacher_id => @teacher2.id
      expect(response.redirect?).to be true
    end
  end

  describe "GET show" do
    it "Displays a homework assignment that belongs to the logged in teacher" do
      get :show, :teacher_id => @teacher.id, :id => @homework.id
      expect(assigns(:homework).user_id).to eq @teacher.id

      expect(response).to render_template('show')
    end

    it "Should redirect user and flash error if the assignment shown does not belong to the user" do 
      get :show, :teacher_id => @teacher2.id, :id => @homework.id
      expect(flash[:error]).to eq 'Unauthorized to do that'
      expect(response.redirect?).to be true
    end
  end

  after(:each) do 
    DatabaseCleaner.clean
  end
end
