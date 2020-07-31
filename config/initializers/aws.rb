if Rails.env.test? || Rails.env.development?
  Aws.config.update({
                      region:            ENV['AWS_REGION'],
                      access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
                      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
                      endpoint:          ENV['AWS_ENDPOINT'],
                      force_path_style:  true
                    })

  storage = Fog::Storage.new({
                               provider:   'Local',
                               local_root: ENV['FOG_LOCAL_ROOT']
                             })

  storage.directories.create(
    key: ENV['AWS_S3_BUCKET']
  )
else
  Aws.config.update({
                      region:      ENV['AWS_REGION'],
                      credentials: Aws::Credentials.new(
                        ENV['AWS_ACCESS_KEY_ID'],
                        ENV['AWS_SECRET_ACCESS_KEY']
                      )
                    })
end

s3        = Aws::S3::Resource.new(region: ENV['AWS_REGION'])
S3_BUCKET = s3.bucket(ENV['AWS_S3_BUCKET'])
