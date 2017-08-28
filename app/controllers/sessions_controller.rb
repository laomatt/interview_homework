class SessionsController < ApplicationController
  skip_before_action :authorize

  def new

  end

  def create
    @user = User.where(user_params).first
    if @user
      session[:user_id] = @user.id
      redirect_to root_url
    else
      user = User.new(user_params)
      if user.save
        session[:user_id] = user.id
        redirect_to root_url
      else
        render :json => { :success => false, :message => user.errors.full_messages }
      end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end

  private

  def user_params
    params.require(:login).permit(:username, :role)
  end
end
