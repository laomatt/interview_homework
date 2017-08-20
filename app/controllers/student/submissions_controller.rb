class Student::SubmissionsController < StudentController
	before_action :set_submission, :except => [:index,:create,:new]

	def index
		@submissions = @student.submissions
	end

	def create
		submission = Submission.new(submission_params)
		homework_assignment = HomeworkAssignment.find(params[:submission][:homework_assignment_id])
		if homework_assignment.user_id != current_user.id
			populate_errors(["You are not permitted to submit for this"])
			return
		else
			submission.homework_assignment_id = current_user.homework_assignments.find(params[:submission][:homework_assignment_id]).id
		end
		if submission.save
			flash[:update] = 'Submitted'
		else
			populate_errors(submission.errors.full_messages)
		end
		redirect_to :back
	end

	def show
		@submission = current_user.submissions.find(params[:id])
		@homework = @submission.homework
	end

	private 

	def submission_params
		params.require(:submission).permit(:content)
	end

	def set_submission
		if params[:submission_id]
			@submission = Submission.find(params[:submission_id])
		else
			@submission = Submission.find(params[:id])
		end
	end
end
