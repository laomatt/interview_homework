class AddFeedbackToSubmission < ActiveRecord::Migration[5.0]
  def change
  	add_column :submissions, :feedback, :text
  end
end
