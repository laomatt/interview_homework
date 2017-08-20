require 'rails_helper'
require 'database_cleaner'
require 'byebug'
DatabaseCleaner.strategy = :truncation

RSpec.describe Student::SubmissionsController, type: :controller do
	# student should not be able to make a submission past an assignments due date
	before(:each) do 
		request.env["HTTP_REFERER"] = 'before page'
    @student = FactoryGirl.create(:student, username: 'student')
		@student2 = FactoryGirl.create(:student, username: 'student2')
		@teacher = FactoryGirl.create(:teacher, username: 'teacher')
		@teacher2 = FactoryGirl.create(:teacher, username: 'teacher2')

    @homework = FactoryGirl.create(
    	:homework, 
    	user_id: @teacher.id, 
    	content: "What happened when Thor blew up the cheese factory in France?"
    	)

    @homework2 = FactoryGirl.create(
    	:homework, 
    	user_id: @teacher.id, 
    	content: "What are Captain Americas dietary restrictions?"
    	)

    @homework3 = FactoryGirl.create(
    	:homework, 
    	user_id: @teacher.id, 
    	content: "What much does the Hulk weigh?"
    	)

    @homework_assignment_overdue = FactoryGirl.create(
    	:homework_assignment, 
    	user_id: @student.id, 
    	homework_id: @homework2.id, 
    	due_date: Date.today - 7
    	)

    @homework_assignment = FactoryGirl.create(
    	:homework_assignment, 
    	user_id: @student.id, 
    	homework_id: @homework.id, 
    	assigned_by: @teacher.id, 
    	due_date: Date.today + 7
    	)

    @homework_assignment2 = FactoryGirl.create(
    	:homework_assignment, 
    	user_id: @student2.id, 
    	homework_id: @homework.id, 
    	due_date: Date.today + 7
    	)

    @homework_assignment3 = FactoryGirl.create(
    	:homework_assignment, 
    	user_id: 5, 
    	homework_id: @homework.id, 
    	due_date: Date.today + 7
    	)

    @homework_assignment4 = FactoryGirl.create(
    	:homework_assignment, 
    	user_id: 56, 
    	homework_id: @homework.id, 
    	due_date: Date.today + 7
    	)

    @submission = FactoryGirl.create(
    	:submission, 
    	homework_assignment_id: @homework_assignment.id, 
    	scorer_id:@teacher.id, content:''
    	)

    
    session[:user_id] = @student.id
  end

  describe "GET index" do 
  	it "gets a list of submissions belonging to the current student" do 
  		get :index, :student_id => @student.id
  		assigns(:submissions).all.each do |submission|
        submission.should be_kind_of(Submission)
        expect(submission.homework_assignment.user_id).to eq @student.id
      end

	  	expect(response).to render_template('index')
  	end

  end

	# POST create
	describe "POST create" do 
		it "makes sure student gets error message if he/she tries to submit past assignment due date" do 
			post :create, :student_id => @student.id, :submission => {:homework_assignment_id=> @homework_assignment_overdue.id, :content => 'De Brie flew everywhere'}
			expect(flash[:error]).to eq "<ul><li>Created at This assignment is past due</li></ul>"
		end

		it "makes sure that a student cannot make a submission for an assignment that doesnt belong to them" do 
			post :create, :student_id => @student.id, :submission => {:homework_assignment_id=> @homework_assignment2.id, :content => 'No German food'}
			expect(flash[:error]).to eq "<ul><li>You are not permitted to submit for this</li></ul>"
		end

		it "makes sure student is able to make a submission" do 
			post :create, :student_id => @student.id, :submission => {:homework_assignment_id=> @homework_assignment.id, :content => 'some answer'}
			expect(flash[:update]).to eq "Submitted"
		end
	end

	# GET show
	describe "GET show" do
		it "makes sure and student cannot see a submission that does not belong to them" do 
			get :show, :id => @submission.id, :student_id => @student.id
			expect(assigns(:submission).id).to eq @submission.id
			expect(assigns(:homework).id).to eq @submission.homework_assignment.homework_id
			
	  	expect(response).to render_template('show')
		end

	end

	after(:each) do 
    DatabaseCleaner.clean
  end
end
