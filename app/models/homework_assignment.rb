class HomeworkAssignment < ApplicationRecord

	attr_accessor :skip_date_validation
	
	belongs_to :user
	belongs_to :homework
	has_many :submissions
	validates :user_id, presence: true
	validate :not_already_past_due, unless: :skip_date_validation
	validates :user_id, uniqueness: {scope: :homework_id}
	default_scope { order(created_at: :desc) }

	def not_already_past_due
		if due_date.nil?
			errors.add(:due_date, "This must have a due date")
		elsif past_due?
			errors.add(:due_date, "This date that is already past due")
		end
	end

	def assigner
		User.find(assigned_by)
	end

	def past_due?
		if due_date
			Date.today > due_date
		else
			false			
		end
	end

	def high_score_color
		if high_score.nil?
			'transparent'
		else
			submissions.select{|e| !e.score.nil? }.max_by {|e| e.score}.color_code
		end
	end

	def high_score
		submissions.select{|e| !e.score.nil? }.map{|e| e.score}.max
	end
end
