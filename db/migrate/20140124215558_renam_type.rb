class RenamType < ActiveRecord::Migration
  def up
  	rename_column :resumes, :type, :category
  end

  def down
  end
end
