require 'rails_helper'
require 'database_cleaner'
require 'byebug'
DatabaseCleaner.strategy = :truncation

RSpec.describe Teacher::SubmissionsController, type: :controller do
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
        assigned_by: @teacher.id, 
        due_date: Date.today + 3
        )

    @homework_assignment2 = FactoryGirl.create(
        :homework_assignment, 
        user_id: @student2.id, 
        homework_id: @homework.id, 
        due_date: Date.today + 3
        )

    @homework_assignment3 = FactoryGirl.create(:homework_assignment,
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
        content:'this is an example answer'
        )

    session[:user_id] = @teacher.id
    request.env["HTTP_REFERER"] = "before page"
  end

  describe "GET show" do
  	it "shows homework" do 
			get :show, :teacher_id => @teacher.id, :id => @submission.id
  		expect(assigns(:homework).user_id).to eq @teacher.id
      expect(response).to render_template('show')
    end

    it "shows a submission for a homework assignment that was assigned by the teacher" do 
      get :show, :teacher_id => @teacher.id, :id => @submission.id
      expect(assigns(:homework_assignment).assigned_by).to eq @teacher.id
    end

  end

  describe "PUT update" do 
  	it "Allows teacher who owns the homework may update a submission by scoring it and providing feedback" do
  		put :update, :id => @submission.id, :teacher_id => @teacher.id, submission: { score: 75, feedback: "this is some feedback" }
  		expect(flash[:update]).to eq "Grade updated"
  		expect(response.redirect?).to be true
  	end

  	it "makes sure to pass error message teachers may not pass in content to submissions" do 
  		put :update, :id => @submission.id, :teacher_id => @teacher.id, submission: { score: 75, content: "this is some changed content" }
  		expect(flash[:error]).to eq "You may not change student content"
  		expect(response.redirect?).to be true
  	end

  	it "Redirects teacher that doesn't own the homework the assignment is of" do 
  		put :update, :id => @submission.id, :teacher_id => @teacher2.id, submission: { score: 75, feedback: "this is some feedback" }
  		expect(flash[:error]).to eq "Unauthorized to do that"
  		expect(response.redirect?).to be true
  	end

  end

  after(:each) do 
    DatabaseCleaner.clean
  end
end
