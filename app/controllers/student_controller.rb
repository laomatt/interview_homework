class StudentController < ApplicationController
	layout 'student_layout'
	before_action :set_and_auth_student, :except => [:grab]

	def grab
		classname = params[:model].constantize
		results = classname.where("#{params[:field]} = ?", params[:field_id])

		if results.empty?
			render :html => 'No submissions'
		else
			render :partial => params[:partial], :locals => { :results => results } 
		end
	end

	
	protected

	def set_and_auth_student
    if not current_user.student?
      redirect_to login_url
    end

		if params[:student_id]
	    @student = User.find(params[:student_id])
		else
			@student = User.find(params[:id])
		end

		if !(current_user.student?) || (current_user != @student)
			flash[:error] = 'you are not allowed to view'
      redirect_to login_url
		end
	end

end
