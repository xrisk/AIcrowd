class PostsController < InheritedResources::Base

  COLAB_URL = 'https://colab.research.google.com/gist/'
  GIST_URL = "https://gist.github.com/"
  USER_NAME = "sujnesh"
  def new
    @post = Post.new
  end

  def index
    @post = Post.friendly.all
  end

  def show
    @post = Post.friendly.find(params[:id])
    if @post.gist_id.present?
      @execute_in_colab_url = COLAB_URL + USER_NAME + '/' + @post.gist_id
    end
    unless @post.external_link.include?("https://colab.research.google.com")
      @external_link = @post.external_link
    end
  end

  def update
  end

  def create
    if !params["notebook_url_fetch"].nil?
      url = params["post"]["external_link"]
      if url.include?("colab.research.google.com")
        notebook_file_path = colab_handler(url)
        @post = Post.new(post_params)
        @post.notebook_file_path = notebook_file_path
        flash[:success] = "Fetched successfully"
        render :new and return
      else
        flash[:success] = "Fetched Successfully"
        return
      end
    end

    post = Posts::CreatePostService.new(post_params).call

    if post.save
      render :index
    else
      flash[:error] = 'Something went wrong'
      render :new
    end
  end

  def destroy
  end

  private

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
      return file_path
    end

    def post_params
      params.require(:post).permit(:title, :tagline, :thumbnail, :description, :external_link, :challenge_id, :submission_id, :notebook_file_path)
    end
end

