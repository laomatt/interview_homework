class Teacher::SubmissionsController < TeacherController
	before_action :set_submission, :except => [:index,:create,:new]

	def new
		
	end

	def index
		
	end

	def show
		@homework = @submission.homework
		@homework_assignment = @submission.homework_assignment
	end

	def update
		@submission = Submission.find(params[:id])
		@homework_assignment = @submission.homework_assignment
		@homework = @homework_assignment.homework

		# the person that is grading has to have assigned the homework, and be the owner of the homework
		if @teacher.id == @homework.user_id
			@submission.assign_attributes(grade_params)
			@submission.scorer_id = current_user.id
			if @submission.save
				flash[:update] = 'Grade updated'
			else
				flash[:error] = @submission.errors.full_messages.join(',')
			end

			if params[:submission][:content]
				flash[:error] = "You may not change student content"
			end
		end

		redirect_to :back
	end

	private 

	def grade_params
		params.require(:submission).permit(:feedback,:score)
	end

	def set_submission
		if params[:submission_id]
			@submission = Submission.find(params[:submission_id])
		else
			@submission = Submission.find(params[:id])
		end
	end
end
