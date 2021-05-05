class AddReferredPageInFeedback < ActiveRecord::Migration[5.2]
  def change
    add_column :feedbacks, :referred_page, :text
  end
end
