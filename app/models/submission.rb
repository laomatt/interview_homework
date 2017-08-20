class Submission < ApplicationRecord
	belongs_to :homework_assignment
	has_one :user, :through => :homework_assignment
	has_one :homework, :through => :homework_assignment
	validate :not_past_due?
	validates_numericality_of :score, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100, :on => :update
	default_scope { order(created_at: :desc) }

	def not_past_due?
		if homework_assignment && (Date.today > homework_assignment.due_date)
			errors.add(:created_at, "This assignment is past due")
		end
	end

	def user_id
		user.id
	end

	def proctor
		if scorer_id.nil?
			'Not scored yet'
		else
			scorer = User.find(scorer_id)
			if scorer.nil?
				User.find(homework.user_id).username
			else
				scorer.username
			end
		end
	end

	def color_code
		case score
		when 0..50
			'#ff4000'
		when 51..59
			'#ff8000'
		when 60..69
			'#ffbf00'
		when 70..79
			'#ffff00'
		when 80..89
			'#bfff00'
		when 90..100
			'#80ff00'
		else
			'white'
		end
	end

end
