class RemoveColumnMarkdown < ActiveRecord::Migration[5.2]
  def change
    remove_column :blogs, :body_markdown, :text
    remove_column :challenge_calls, :description_markdown, :text
    remove_column :job_postings, :description_markdown, :text
    remove_column :participation_terms, :terms_markdown, :text
  end
end
