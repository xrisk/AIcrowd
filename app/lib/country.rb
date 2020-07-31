class Country
  def self.countries(p_ids)
    countries = []
    Participant.where(id: p_ids).pluck(:country_cd).each { |code| countries << country_name(code) if code.present? }
    countries
  end

  def self.country_name(country_cd)
    return unless country_cd

    ISO3166::Country[country_cd]&.name
  end

  def self.country_cd(country_name)
    return unless country_name.present?

    ISO3166::Country.find_country_by_name(country_name).alpha2
  end

  def self.affiliations(p_ids)
    Participant.where(id: p_ids).pluck(:affiliation).reject { |aff| aff.blank? }
  end
end
