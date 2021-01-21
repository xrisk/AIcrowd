namespace :compress_images do
  desc "compress images"
  task compress_challenge_images: :environment do
    STORAGE_PATH = "https://d3121tj603apyt.cloudfront.net"
    Challenge.all.each do |challenge|
      puts challenge.challenge
      image_file = File.join(STORAGE_PATH, challenge.image_file.path) if challenge.image_file.path.present?
      social_media_image_file = File.join(STORAGE_PATH, challenge.social_media_image_file.path) if challenge.social_media_image_file.path.present?
      banner_file = File.join(STORAGE_PATH, challenge.banner_file.path) if challenge.banner_file.path.present?
      banner_mobile_file = File.join(STORAGE_PATH, challenge.banner_mobile_file.path) if challenge.banner_mobile_file.path.present?
      if image_file.present?
        download_image_file = open(image_file) rescue nil
        next if download_image_file.blank?
        image_file_name = image_file.split('/')[-1]
        image_file_path = "#{Rails.root.join('public', 'uploads', image_file_name)}"
        IO.copy_stream(download_image_file, image_file_path)
        upload_image_file = ActionDispatch::Http::UploadedFile.new({
          filename: image_file_name,
          type: "image/#{File.extname(image_file_name)}",
          tempfile: File.new(image_file_path)
        })
      end

      if social_media_image_file.present?
        download_social_media_image_file = open(social_media_image_file) rescue nil
        social_media_image_file_name = social_media_image_file.split('/')[-1]
        next if File.extname(social_media_image_file_name) == "gif"
        social_media_image_file_path = "#{Rails.root.join('public', 'uploads', social_media_image_file_name)}"
        IO.copy_stream(download_social_media_image_file, social_media_image_file_path)
        upload_social_media_image_file = ActionDispatch::Http::UploadedFile.new({
          filename: social_media_image_file_name,
          type: "image/#{File.extname(social_media_image_file_name)}",
          tempfile: File.new(social_media_image_file_path)
        })
      end

      if banner_file.present?
        download_banner_file = open(banner_file) rescue nil
        next if download_banner_file.blank?
        banner_file_name = banner_file.split('/')[-1]
        banner_file_path = "#{Rails.root.join('public', 'uploads', banner_file_name)}"
        IO.copy_stream(download_banner_file, banner_file_path)
        upload_banner_file = ActionDispatch::Http::UploadedFile.new({
          filename: banner_file_name,
          type: "image/#{File.extname(banner_file_name)}",
          tempfile: File.new(banner_file_path)
        })
      end

      if banner_mobile_file.present?
        download_banner_mobile_file = open(banner_mobile_file) rescue nil
        next if download_banner_mobile_file.blank?
        banner_mobile_file_name = banner_mobile_file.split('/')[-1]
        banner_mobile_file_path = "#{Rails.root.join('public', 'uploads', banner_mobile_file_name)}"
        IO.copy_stream(download_banner_mobile_file, banner_mobile_file_path)
        upload_banner_mobile_file = ActionDispatch::Http::UploadedFile.new({
          filename: banner_mobile_file_name,
          type: "image/#{File.extname(banner_mobile_file_name)}",
          tempfile: File.new(banner_mobile_file_path)
        })
      end

      challenge.image_file = upload_image_file if upload_image_file.present?
      challenge.social_media_image_file = upload_social_media_image_file if upload_social_media_image_file.present?
      challenge.banner_file = upload_banner_file if upload_banner_file.present?
      challenge.banner_mobile_file = upload_banner_mobile_file if upload_banner_mobile_file.present?

      challenge.save!
    end
  end

  task compress_organizer_images: :environment do
    Organizer.all.each do |organizer|
      image_file = File.join(STORAGE_PATH, organizer.image_file.path) if organizer.image_file.path.present?
      if image_file.present?
        download_image_file = open(image_file) rescue nil
        next if download_image_file.blank?
        image_file_name = image_file.split('/')[-1]
        image_file_path = "#{Rails.root.join('public', 'uploads', image_file_name)}"
        IO.copy_stream(download_image_file, image_file_path)
        upload_image_file = ActionDispatch::Http::UploadedFile.new({
          filename: image_file_name,
          type: "image/#{File.extname(image_file_name)}",
          tempfile: File.new(image_file_path)
        })
      end

      organizer.image_file = upload_image_file if upload_image_file.present?
      organizer.save!
    end
  end

  task compress_participant_images: :environment do
    Participant.all.each do |participant|
      image_file = participant.image_file
      if image_file.present?
        download_image_file = open(image_file)
        image_file_name = download_image_file.base_uri.to_s.split('/')[-1]
        image_file_path = "#{Rails.root.join('public', 'uploads', file_name)}"
        IO.copy_stream(download, file_path)
        upload_image_file = ActionDispatch::Http::UploadedFile.new({
          filename: image_file_name,
          type: "image/#{image_file_name.extension}",
          tempfile: File.new(image_file_path)
        })
      end

      participant.image_file = upload_image_file if upload_image_file.present?
      participant.save!
    end
  end



  task compress_partner_images: :environment do
    Partner.all.each do |partner|
      image_file = partner.image_file
      if image_file.present?
        download_image_file = open(image_file)
        image_file_name = download_image_file.base_uri.to_s.split('/')[-1]
        image_file_path = "#{Rails.root.join('public', 'uploads', file_name)}"
        IO.copy_stream(download, file_path)
        upload_image_file = ActionDispatch::Http::UploadedFile.new({
          filename: image_file_name,
          type: "image/#{image_file_name.extension}",
          tempfile: File.new(image_file_path)
        })
      end

      partner.image_file = upload_image_file if upload_image_file.present?
      partner.save!
    end
  end

  task compress_success_story_images: :environment do
    SuccessStory.all.each do |success_story|
      image_file = success_story.image_file
      if image_file.present?
        download_image_file = open(image_file)
        image_file_name = download_image_file.base_uri.to_s.split('/')[-1]
        image_file_path = "#{Rails.root.join('public', 'uploads', file_name)}"
        IO.copy_stream(download, file_path)
        upload_image_file = ActionDispatch::Http::UploadedFile.new({
          filename: image_file_name,
          type: "image/#{image_file_name.extension}",
          tempfile: File.new(image_file_path)
        })
      end

      success_story.image_file = upload_image_file if upload_image_file.present?
      success_story.save!
    end
  end
end