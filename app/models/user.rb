class User < ActiveRecord::Base
  enum role: [:teacher, :student]

  validates :username, presence: true, uniqueness: true
  validates :role, presence: true

  has_many :homeworks
  has_many :homework_assignments

  has_many :submissions, :through => :homework_assignments

  def teacher?
  	role == 'teacher'
  end

   def student?
  	role == 'student'
  end
end
