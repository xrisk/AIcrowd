namespace :publications do
  desc "Import publications data from `publications_data.csv` file to database"
  task import_publications: :environment do
    require 'csv'
    # Read csv file
    csv = CSV.parse(File.read(Rails.root.join('lib', 'tasks', 'publication_data.csv')), headers: true)

    csv.each do |row|

      # Skip if publication already exists
      title = row["Title"].to_s.strip
      next if Publication.where(title: title).exists?

      # Get challenge name if present
      if row["Challenge Name"].present?
        slug = row["Challenge Name"].split('/')[-1]
        challenge = begin
                      Challenge.friendly.find(slug)
                    rescue StandardError
                      nil
                    end
        challenge_id = begin
                         challenge.id
                       rescue StandardError
                         nil
                       end
      else
        challenge_id = nil
      end

      # Extract data from csv file
      authors = row["Author"].to_s.split(",").map!(&:strip)
      paper_link = row["Paper Link"].to_s.strip
      publication_date = Date.parse(row["Publication Date"].to_s.strip)
      venue = row["Venue"].to_s.strip
      citations = row["Citation"].to_s.strip.to_i
      abstract = row["Abstract"].to_s.strip
      aicrowd_contributed = row["AIcrowd Contributed"].to_s.strip.present?
      tags = row["Tags"].to_s.split(",").map(&:strip)

      # Create publication
      publication = Publication.create!(title: title, publication_date: publication_date, challenge_id: challenge_id, no_of_citations: citations, aicrowd_contributed: aicrowd_contributed, abstract: abstract)

      # Assign authors to publication, create a new author in database if does not exist
      seq = 0
      authors.each do |author|
        publication_author = PublicationAuthor.where(name: author, publication: publication).first_or_create!
        publication_author.sequence = seq
        publication_author.save!
        seq += 1
      end

      # Assign venues to publication, create a new venue in database if does not exist
      db_venues = PublicationVenue.where(venue: venue)
      publication.venues << (db_venues.empty? ? PublicationVenue.create!(venue: venue, short_name: venue) : db_venues.first)

      # Assign links to publication, create a new link in database if does not exist
      PublicationExternalLink.create!(name: "Download", link: paper_link, publication: publication, icon:) if paper_link != ""

      # Assign categories to publication, create a new category in database if does not exist
      tags.each do |category|
        publication.categories << Category.where(name: category).first_or_create!
      end
    end

  end

end
