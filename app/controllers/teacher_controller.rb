class TeacherController < ApplicationController
	layout 'teacher_layout'
	before_action :authorize
	before_action :set_teacher, :except => [:grab]

	def grab
		classname = params[:model].constantize
		results = classname.where("#{params[:field]} = ?", params[:field_id])

		render :partial => params[:partial], :locals => { :results => results } 
	end

	def set_teacher
		if params[:teacher_id]
			@teacher = User.find(params[:teacher_id])
		else
			@teacher = User.find(params[:id])
		end
		
		if !(current_user.teacher?) || (current_user != @teacher)
			flash[:error] = 'Unauthorized to do that'
      redirect_to login_url
    end
	end
end
