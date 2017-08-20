class AddAssignedByToHomeworkAssignments < ActiveRecord::Migration[5.0]
  def change
  	add_column :homework_assignments, :assigned_by, :integer
  end
end
