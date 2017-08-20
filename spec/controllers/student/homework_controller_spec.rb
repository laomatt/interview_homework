require 'rails_helper'
require 'database_cleaner'
require 'byebug'
DatabaseCleaner.strategy = :truncation

RSpec.describe Student::HomeworkController, type: :controller do

  before(:each) do 
    @student = FactoryGirl.create(:student, username: 'student')
		@student2 = FactoryGirl.create(:student, username: 'student2')
		@teacher = FactoryGirl.create(:teacher, username: 'teacher')
    @homework = FactoryGirl.create(:homework, user_id: @teacher.id)

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
      user_id: 5, homework_id: 
      @homework.id, 
      due_date: Date.today + 3
      )

    @homework_assignment4 = FactoryGirl.create(
      :homework_assignment, 
      user_id: 56, 
      homework_id: @homework.id, 
      due_date: Date.today + 3
      )

    session[:user_id] = @student.id
  end

  describe "GET index" do
    it "lists all student Homework Assignments" do
      get :index, :student_id => @student.id
      assigns(:homeworks).all.each do |hwa|
        hwa.should be_kind_of(HomeworkAssignment)
        expect(hwa.user_id).to eq @student.id
      end

      expect(response).to render_template('index')
    end

    it "Should redirect user if the assignment list shown does not belong to the user" do 
      get :index, :student_id => @student2.id
      expect(response.redirect?).to be true
    end
  end

  describe "GET show" do
    it "Displays a homework assignment that belongs to the logged in student" do
      get :show, :student_id => @student.id, :id => @homework_assignment.id
      expect(assigns(:homework_assignment).user_id).to eq @student.id
      expect(response).to render_template('show')
    end

    it "Should redirect user if the assignment shown does not belong to the user" do 
      get :show, :student_id => @student2.id, :id => @homework_assignment.id
      expect(response.redirect?).to be true
    end
  end

  after(:each) do 
    DatabaseCleaner.clean
  end
end
