class Teacher::HomeworkAssignmentsController < TeacherController
	before_action :set_assignment, :except => [:create]
	before_action :verify_teacher, :only => [:create]

	def create
		assignment = HomeworkAssignment.new(assignment_params)
		assignment.assigned_by = current_user.id
		if assignment.save
			flash[:update] = 'assigned'
		else
			populate_errors(assignment.errors.full_messages)
		end
		
		render :partial => '/teacher/homework/assignments_container', :locals => { :results => assignment.homework.homework_assignments }
	end

	def show
		@homework = current_user.homeworks.find(@homework_assignment.homework.id)
	end

	private

	def set_assignment
		if params[:homework_assignment_id]
			@homework_assignment = HomeworkAssignment.find(params[:homework_assignment_id])
		else
			@homework_assignment = HomeworkAssignment.find(params[:id])
		end

		if @homework_assignment.assigned_by != current_user.id
			populate_errors(["You cannot view this assignment"])
			redirect_to login_url
		end
	end

	def verify_teacher
		@homework = Homework.find(params[:assignment][:homework_id])
		if @homework.user != current_user
			populate_errors(["You cannot assign this homework"])
			redirect_to login_url
		end
	end
	
	def homework_params
		params.require(:homework).permit(:title,:content)
	end

	def assignment_params
		params.require(:assignment).permit(:user_id,:homework_id,:due_date)
	end
end
