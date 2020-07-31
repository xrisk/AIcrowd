CarrierWave.configure do |config|
  if Rails.env.development? || Rails.env.test?
    config.asset_host      = "#{ENV['DOMAIN_NAME']}/assets"
    config.fog_credentials = {
      provider:   'Local',
      local_root: ENV['FOG_LOCAL_ROOT']
    }
    config.fog_directory   = ENV['AWS_S3_BUCKET']
  else
    config.asset_host      = "https://#{ENV['CLOUDFRONT_IMAGES_DOMAIN']}"
    config.fog_credentials = {
      provider:              'aws',
      aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region:                ENV['AWS_REGION']
    }
    config.fog_directory   = ENV['AWS_S3_BUCKET']
  end
end
