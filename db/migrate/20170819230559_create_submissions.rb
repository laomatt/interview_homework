class CreateSubmissions < ActiveRecord::Migration[5.0]
  def change
    create_table :submissions do |t|
	  	t.integer :homework_assignment_id
	  	t.integer :scorer_id
	  	t.text :content
	  	t.float :score
      t.timestamps
    end
  end
end
