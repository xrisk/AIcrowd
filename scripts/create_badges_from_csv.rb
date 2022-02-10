require 'csv'
csv = CSV.parse(File.read('badges_data.csv'), headers: true)
csv.each do |row|
  badge = AicrowdBadge.where(name: row["name"], level: row["level"]).first
  if badge.present?
  badge.update_attributes(
    description: row["description"],
    badge_type_id: row["badge_type_id"],
    code: row["code"],
    badges_event_id: row["badges_event_id"],
    image: row["image"],
    level: row["level"],
    target: row["target"],
    social_message: row["social_message"],
    sub_module: row["sub_module"],
    active: row["active"]
  )
  else
    AicrowdBadge.create!(
      name: row["name"],
      description: row["description"],
      badge_type_id: row["badge_type_id"],
      code: row["code"],
      badges_event_id: row["badges_event_id"],
      image: row["image"],
      level: row["level"],
      target: row["target"],
      social_message: row["social_message"],
      sub_module: row["sub_module"],
      active: row["active"]
    )
  end
end