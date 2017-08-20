class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authorize

  def search
    results = []
    classname = params[:model].split('_').map{|e| e.capitalize}.join('').constantize
    class_table = params[:model].downcase.pluralize

    join = params[:join]
    model = params[:model]
    phrase = params[:phrase].downcase
    search_field = params[:field]
    extra = ''
    if class_table != 'users'
      extra = " AND #{class_table}.user_id=#{current_user.id}"
    end

    if params[:join].nil?
      results = classname.where("lower(#{class_table}.#{search_field}) like ?#{extra}", "%#{phrase}%")
    else
      join_table = params[:join].downcase.pluralize
      joinclass = params[:join].split('_').map{|e| e.capitalize}.join('').constantize
      results = classname.joins("join #{join_table} on #{class_table}.#{join.to_s.downcase}_id=#{join.to_s.downcase.pluralize}.id").where("lower(#{join.to_s.downcase.pluralize}.#{search_field}) like ? AND #{class_table}.user_id=#{current_user.id}", "%#{phrase}%")
    end

    render :partial => params[:partial], :locals => {:results => results.distinct.first(params[:limit]), :limit => params[:limit], :extras => {:homework => params[:homework], :user_scope => params[:user_scope]}}
  end

  def populate_errors(errors)
    html = '<ul>'
    errors.each do |err|
      html += "<li>#{err}</li>"
    end
    html += '</ul>'
    flash[:error] = html 
  end

  protected

  # Private: Ensures User is logged in.
  def authorize
    if not current_user
      redirect_to login_url
    end
  end


  # Private: Returns the current logged in User.
  def current_user
    @current_user ||= session[:user_id] && User.find(session[:user_id])
  end
  helper_method :current_user
end
