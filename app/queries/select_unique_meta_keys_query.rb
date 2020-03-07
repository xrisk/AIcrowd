class SelectUniqueMetaKeysQuery
  def initialize(relation = Leaderboard.all)
    @relation = relation
  end

  def call
    relation.reorder('').pluck('DISTINCT json_object_keys(meta)')
  end

  private

  attr_reader :relation
end
