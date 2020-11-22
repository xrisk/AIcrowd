module Posts
  class CreatePostService < BaseService

    def initialize params
      @params = params
    end

    def call
      post = Post.new(params)
      external_link = params[:post][:external_link]

      if external_link.present? && external_link.include?("colab.research.google.com")
        filename = colab_handler(external_link)
        notebook_file_path = Rails.root.join('public', 'uploads',filename)
      elsif params["post"]["notebook_file"].present?
        uploaded_file = params["post"]["notebook_file"]
        filename = uploaded_file.original_filename
        notebook_file_path = Rails.root.join('public', 'uploads',filename)
        File.open(notebook_file_path, 'wb'){ |file| file.write(uploaded_file.read)}
      end

      if notebook_file_path.present?
        `jupyter nbconvert --to html #{notebook_file_path}`
        notebook_gist_url = `gist #{notebook_file_path}`
        post.notebook_url = upload_to_s3(notebook_file_path)
        html_filename = filename.chomp(File.extname(filename)) + (".html")
        post.notebook_html = File.read(Rails.root.join('public', 'uploads', html_filename)).html_safe
        post.gist_id = notebook_gist_url.strip.gsub(GIST_URL, "")
      end

      post
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

      download = open(download_url)
      file_name = "#{SecureRandom.uuid}.ipynb"
      file_path = "#{Rails.root.join('public', 'uploads', file_name)}"
      IO.copy_stream(download, file_path)
      return file_name
    end

    def upload_to_s3 filepath
      s3_key          = "colab_notebooks/#{SecureRandom.hex}_#{filename}"
      file            = attachment.tempfile
      s3_obj          = Aws::S3::Resource.new.bucket(ENV['AWS_S3_SHARED_BUCKET']).object(s3_key)
      s3_obj.upload_file(file, acl: 'public-read')
      url             = s3_obj.public_url
    end

  end
end