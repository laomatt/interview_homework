class WelcomeController < ApplicationController
  def index
  	if current_user.teacher?
  		redirect_to teacher_homework_index_path(:teacher_id => current_user.id)
  	else
  		redirect_to student_homework_index_path(:student_id => current_user.id)
  	end
  end
end
