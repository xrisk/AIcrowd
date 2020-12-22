class PostsController < InheritedResources::Base
  before_action :authenticate_participant!, except: [:show, :index]
  before_action :set_post, only: [:show, :edit, :update]

  COLAB_URL = ENV['COLAB_URL']
  GIST_URL = ENV['GIST_URL']
  USER_NAME = ENV['GIST_USERNAME']

  def new
    @post = Post.new
    @post.participant_id = current_participant.id
  end

  def set_post
    @post = Post.friendly.find(params[:id])
  end

  def index
    params[:page] ||= 1
    @post = Post.paginate(page: params[:page], per_page: 10)
  end

  def show
    if @post.gist_id.present?
      @execute_in_colab_url = COLAB_URL + USER_NAME + '/' + @post.gist_id
    end
    unless @post.external_link.present? && @post.external_link.include?("https://colab.research.google.com")
      @external_link = @post.external_link
    end
    commontator_thread_show(@post)
  end

  def update
    if !params["remove_notebook"].nil?
      @post = remove_notebook(@post)
      render :edit and return
    end

    if !params["notebook_url_fetch"].nil?
      url = params["post"]["external_link"]
      @post.external_link = url
      if url.include?("colab.research.google.com")
        notebook_file_path = colab_handler(url)
        @post.notebook_file_path = notebook_file_path
        flash[:success] = "Fetched successfully"
        render :edit and return
      else
        flash[:success] = "Fetched Successfully"
        return
      end
    end

    @post.update(post_params)

    if params["post"]["external_link"].present? && params["post"]["external_link"].include?("https://colab.research.google.com")
      if params["post"]["notebook_file_path"].blank?
        flash[:error] = "We noticed you are trying colab link, please use \"Fetch\" button before submitting this form"
        render :edit and return
      end
    end

    @post = Posts::PostService.new(post_params, @post).call

    if @post.save
      render :index
    else
      flash[:error] = t(@post.errors[:base])
      render :new
    end
  end

  def create
    if !params["notebook_url_fetch"].nil?
      @post = Post.new(post_params)
      url = params["post"]["external_link"]
      if url.include?("colab.research.google.com")
        notebook_file_path = colab_handler(url)
        @post.notebook_file_path = notebook_file_path
        flash[:success] = "Fetched successfully"
        render :new and return
      else
        flash[:success] = "Fetched Successfully"
        return
      end
    end

    if params["post"]["external_link"].present? && params["post"]["external_link"].include?("https://colab.research.google.com")
      if params["post"]["notebook_file_path"].blank?
        flash[:error] = "We noticed you are trying colab link, please use \"Fetch\" button before submitting this form"
        @post = Post.new(post_params)
        render :new and return
      end
    end

    @post = Posts::PostService.new(post_params).call

    @post.participant = current_participant

    if @post.save
      render :index
    else
      flash[:error] = @post.errors
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
      params.require(:post).permit(:id, :title, :tagline, :thumbnail, :description, :external_link, :challenge_id, :submission_id, :notebook_file_path)
    end

    def remove_notebook(post)
      post.gist_id = nil
      post.notebook_s3_url = nil
      post.notebook_html = nil
      if post.external_link.present? && post.external_link.include?("colab.research.google.com/drive/")
        post.external_link = nil
      end
      post.save!
      post
    end
end

