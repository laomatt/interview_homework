class User < ActiveRecord::Base
  enum role: [:teacher, :student]

  validates :username, presence: true, uniqueness: true
  validates :role, presence: true

  has_many :homeworks
  has_many :homework_assignments

  has_many :submissions, :through => :homework_assignments

  def self.teachers
    select { |e| e.teacher? }  
  end

  def self.students
    select { |e| e.student? }  
  end

  def teacher?
  	role == 'teacher'
  end

  def student?
  	role == 'student'
  end

  def has_homework?(homework_id)
    homeworks.any? { |e| e.id == homework_id.to_i }
  end

  def assign_button(homework_id)
    if teacher?
      "N/A"
    elsif homework_assignments.map { |e| e.homework_id }.include?(homework_id.to_i)
      "Assigned"
    else
      "Assign"  
    end
  end
end
