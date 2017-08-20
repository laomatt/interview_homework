class Homework < ApplicationRecord
	belongs_to :user
	has_many :homework_assignments
	has_many :homework_assignment_scores, :through => :homework_assignments
	has_many :submissions, :through => :homework_assignments
end
