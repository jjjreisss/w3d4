class RemoveQuestionIdFromResponses < ActiveRecord::Migration
  def change
    remove_column :responses, :question_id, :integer
  end
end
