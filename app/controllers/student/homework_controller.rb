class Student::HomeworkController < StudentController
	before_action :set_homework, :except => [:index,:grab,:show]

	def index
		if params[:page]
			@homeworks = current_user.homework_assignments.paginate(:page => params[:page], :per_page => 40)
		else
			@homeworks = current_user.homework_assignments.paginate(:page => 1, :per_page => 40)
		end
	end

	def show
		@homework_assignment = current_user.homework_assignments.find(params[:id])
		@homework = @homework_assignment.homework
	end

	protected 

	def set_homework
		if params[:homework_id]
			@homework = Homework.find(params[:homework_id])
		else
			@homework = Homework.find(params[:id])
		end
	end


end
