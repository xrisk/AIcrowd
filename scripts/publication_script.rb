require 'csv'
csv = CSV.parse(File.read('publication_new_additions.csv'), headers: true)
csv.each do |row|
  if row["Challenge Name"].present?
    slug = row["Challenge Name"].split('/')[-1]
    challenge = Challenge.friendly.find(slug) rescue nil
    challenge_id = challenge.id rescue nil
  else
    challenge_id = nil
  end
  title = row["Title"]
  authors = row["Author"].split(',')
  publication_date = Date.parse(row["Publication Date"])
  venue = row["Venue"]
  citations = row["Citation"].to_i
  abstract = row["Abstract"]
  aicrowd_contributed = row["aicrowd_contributed"].present?
  publication = Publication.create!(title: title, publication_date: publication_date, challenge_id: challenge_id, no_of_citations: citations, aicrowd_contributed: aicrowd_contributed, abstract: abstract)
  authors.each do |author|
    publication.authors.create!(name: author)
  end
  publication.venues.create!(venue: venue, short_name: venue)
end