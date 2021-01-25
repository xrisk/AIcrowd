module Posts
  class PostService < BaseService
    include ActiveModel::Model

    def initialize(url)
      @url = url
    end

    def call
      notebook_file_path = colab_handler(@url)
      `jupyter nbconvert --template basic --to html #{notebook_file_path}`
      filename = File.basename(notebook_file_path)
      html_filename = filename.chomp(File.extname(filename)) + (".html")
      unless File.exist?(Rails.root.join('public', 'uploads', html_filename))
        errors.add(:base, "Sorry, the notebook seems to be private. Please make it public and try again.")
        return
      end
      notebook_gist_url = `gist #{notebook_file_path}`
      notebook_s3_url = upload_to_s3(notebook_file_path, filename)
      notebook_html = File.read(Rails.root.join('public', 'uploads', html_filename)).html_safe
      gist_id = notebook_gist_url.strip.gsub(ENV['GIST_URL'], "")
      File.delete(notebook_file_path) if File.exist?(notebook_file_path)
      File.delete(Rails.root.join('public', 'uploads', html_filename)) if File.exist?(Rails.root.join('public', 'uploads', html_filename))

       return {notebook_s3_url: notebook_s3_url, notebook_html: notebook_html, gist_id: gist_id}
    end

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
