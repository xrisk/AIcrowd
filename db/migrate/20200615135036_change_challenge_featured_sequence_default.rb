class ChangeChallengeFeaturedSequenceDefault < ActiveRecord::Migration[5.2]
  def change
    change_column_default :challenges, :featured_sequence, nil
  end
end
