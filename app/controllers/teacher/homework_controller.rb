class Teacher::HomeworkController < TeacherController
	
	before_action :set_homework, :except => [:index, :new, :create, :grab, :view_submission,:grade_submission]

	def index
		if params[:page]
			@homeworks = @teacher.homeworks.paginate(:page => params[:page], :per_page => 40)
		else
			@homeworks = @teacher.homeworks.paginate(:page => 1, :per_page => 40)
		end
	end

	def create
		homework = Homework.new(homework_params)
		homework.user_id = @teacher.id
		if homework.save
			redirect_to teacher_homework_path(:teacher_id => @teacher.id, :id => homework.id)
		else
			populate_errors(homework.errors.full_messages)
			redirect_to :back
		end
	end

	def update
		@homework.assign_attributes(homework_params)
		if @homework.save
			redirect_to teacher_homework_path(:teacher_id => @teacher.id, :id => @homework.id)
		else
			populate_errors(@homework.errors.full_messages)
			redirect_to :back
		end
	end

	private
	
	def grade_params
		params.require(:submission).permit(:feedback,:score)
	end

	def homework_params
		params.require(:homework).permit(:title,:content)
	end

	def assignment_params
		params.require(:assignment).permit(:user_id,:homework_id,:due_date)
	end

	def set_homework
		if @teacher.has_homework?(params[:id])
			@homework = current_user.homeworks.find(params[:id])
		else
			flash[:error] = 'You are not authorized to view that homework'
			redirect_to login_url
		end
	end


end
