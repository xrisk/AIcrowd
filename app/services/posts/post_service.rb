module Posts
  class PostService < BaseService
    include ActiveModel::Model

    def initialize(params, post=nil)
      @params = params
      @post = post
    end

    def call
      post = @post
      if post.nil?
        post = Post.new(@params)
      end

      if @params[:notebook_file].present?
        uploaded_file = @params[:notebook_file]
        filename = uploaded_file.original_filename
        notebook_file_path = Rails.root.join('public', 'uploads',filename)
        File.open(notebook_file_path, 'wb'){ |file| file.write(uploaded_file.read)}
      elsif @params[:notebook_file_path].present?
        notebook_file_path = @params[:notebook_file_path]
        filename = File.basename(notebook_file_path)
      end

      if notebook_file_path.present?
        `jupyter nbconvert --ExecutePreprocessor.allow_errors=true --template basic --to html #{notebook_file_path}`
        html_filename = filename.chomp(File.extname(filename)) + (".html")
        unless File.exist?(Rails.root.join('public', 'uploads', html_filename))
          errors.add(:base, "Sorry, the notebook seems to be private. Please make it public and try again.")
          return
        end
        notebook_gist_url = `gist #{notebook_file_path}`
        post.notebook_s3_url = upload_to_s3(notebook_file_path, filename)
        post.notebook_html = File.read(Rails.root.join('public', 'uploads', html_filename)).html_safe
        post.gist_id = notebook_gist_url.strip.gsub(ENV['GIST_URL'], "")
        File.delete(notebook_file_path) if File.exist?(notebook_file_path)
        File.delete(Rails.root.join('public', 'uploads', html_filename)) if File.exist?(Rails.root.join('public', 'uploads', html_filename))
      end

       return post
    end

    def upload_to_s3 filepath, filename
      s3_key          = "colab_notebooks/#{SecureRandom.hex}_#{filename}"
      s3_obj          = Aws::S3::Resource.new.bucket(ENV['AWS_S3_BUCKET']).object(s3_key)
      s3_obj.upload_file(filepath, acl: 'public-read')
      url             = s3_obj.public_url
    end

  end
end
