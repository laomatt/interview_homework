class Submission < ApplicationRecord
	belongs_to :homework_assignment
	has_one :user, :through => :homework_assignment
	has_one :homework, :through => :homework_assignment

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

end
