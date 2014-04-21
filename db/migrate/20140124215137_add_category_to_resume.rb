class AddCategoryToResume < ActiveRecord::Migration
  def change
  	add_column :resumes, :type, :string
  end
end
