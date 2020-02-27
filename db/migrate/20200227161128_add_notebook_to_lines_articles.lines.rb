# This migration comes from lines (originally 20200220184547)
class AddNotebookToLinesArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :lines_articles, :notebook, :text
  end
end
