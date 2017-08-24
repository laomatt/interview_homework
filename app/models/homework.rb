class Homework < ApplicationRecord
	belongs_to :user
	has_many :homework_assignments
	has_many :homework_assignment_scores, :through => :homework_assignments
	has_many :submissions, :through => :homework_assignments
	default_scope { order(created_at: :desc) }

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

	def unscored_submissions?
		submissions.any? { |e| e.score.nil? }
	end
end
