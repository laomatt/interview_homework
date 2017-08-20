class Teacher::HomeworkController < ApplicationController
	layout 'teacher_layout'
	before_action :authorize, :set_teacher

	def index
		if params[:page]
			@homeworks = @teacher.homeworks.paginate(:page => params[:page], :per_page => 10)
		else
			@homeworks = @teacher.homeworks.paginate(:page => 1, :per_page => 10)
		end
	end

	def show
		@homework = current_user.homeworks.find(params[:id])
	end

	def view_assignment
		@homework_assignment = HomeworkAssignment.find(params[:id])
		@homework = current_user.homeworks.find(@homework_assignment.homework.id)
		if !current_user.homeworks.include?(@homework_assignment.homework.id)
      # redirect_to login_url
		end
	end

	def view_submission
		@submission = Submission.find(params[:id])
		@homework = @submission.homework
		
	end

	def grade_submission
		@submission = Submission.find(params[:id])
		@homework_assignment = @submission.homework_assignment
		@homework = @homework_assignment.homework

		# the person that is grading has to have assigned the homework, and be the owner of the homework
		if current_user.id == @homework.user_id
			@submission.update_attributes(grade_params)
			@submission.scorer_id = current_user.id
			@submission.save
		end

		flash[:update] = 'Grade updated'

		redirect_to :back
		
	end


	protected
	
	def grade_params
		params.require(:grade).permit(:feedback,:score)
	end

	def set_teacher
		 if not current_user.teacher?
      redirect_to login_url
    end
		@teacher = current_user
	end
end
