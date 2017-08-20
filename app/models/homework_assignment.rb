class HomeworkAssignment < ApplicationRecord
	belongs_to :user
	belongs_to :homework
	has_many :submissions


end
