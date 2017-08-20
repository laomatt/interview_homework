class CreateHomeworkAssignments < ActiveRecord::Migration[5.0]
  def change
    create_table :homework_assignments do |t|
    	t.integer :user_id
    	t.integer :homework_id

    	t.float :score
    	t.integer :scorer_id
    	
    	t.date :due_date

      t.timestamps
    end
  end
end
