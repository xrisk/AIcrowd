module Notebooks
  class NotebookBaseService < BaseService
    include ActiveModel::Model
    include S3FilesHelper

    def upload_to_s3 filepath, filename
      s3_key          = "colab_notebooks/#{SecureRandom.hex}_#{filename}"
      s3_obj          = Aws::S3::Resource.new.bucket(ENV['AWS_S3_BUCKET']).object(s3_key)
      s3_obj.upload_file(filepath, acl: 'public-read')
      url             = s3_obj.public_url
    end

    def colab_handler(url)
      if url.include? "colab.research.google.com/drive/"
        colab_id = url.scan(/[-\w]{25,}/)[0]
        download_url = "https://docs.google.com/uc?export=download&id=#{colab_id}"
      elsif url.include? "colab.research.google.com/github/"
        github_url = url.scan(/github(.*)/)[0][0]
        download_url = "https://github.com" + github_url.split("#")[0]
        download_url = download_url.gsub("blob", "raw")
      elsif url.include?("colab.research.google.com/gist/")
        gist_url = url.scan(/gist(.*)/)[0][0]
        download_url = "https://gist.github.com" + gist_url.split("#")[0] + "/raw"
      else
        download_url = s3_expiring_url(url)
      end
      download = open(download_url) rescue nil
      return if download.nil?
      file_name = "#{SecureRandom.uuid}.ipynb"
      file_path = "#{Rails.root.join('public', 'uploads', file_name)}"
      IO.copy_stream(download, file_path)
      return file_path
    end

  end
end
