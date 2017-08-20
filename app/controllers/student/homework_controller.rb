class Student::HomeworkController < ApplicationController
	layout 'student_layout'
	before_action :set_and_auth_student

	def index
		if params[:page]
			@homeworks = current_user.homework_assignments.paginate(:page => params[:page], :per_page => 10)
		else
			@homeworks = current_user.homework_assignments.paginate(:page => 1, :per_page => 10)
		end
	end

	def show
		@homework_assignment = current_user.homework_assignments.find(params[:id])
		@homework = @homework_assignment.homework
	end

	def view_submission
		@submission = current_user.submissions.find(params[:id])
		@homework = @submission.homework
	end

	def create_submission
		submission = Submission.new(submission_params)
		submission.homework_assignment_id = current_user.homework_assignments.find(params[:submission][:homework_assignment_id]).id
		if submission.save
			flash[:update] = 'Submitted'
		else
			html = '<ul>'
			submission.errors.full_messages.each do |err|
				html += "<li>#{err}</li>"
			end
			html += '</ul>'
			flash[:error] = html
		end
		redirect_to :back
	end

	protected

	def set_and_auth_student
    if not current_user.student?
      redirect_to login_url
    end
	end

	def submission_params
		params.require(:submission).permit(:content)
	end
end
