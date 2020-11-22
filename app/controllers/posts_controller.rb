class PostsController < InheritedResources::Base

  COLAB_URL = 'https://colab.research.google.com/gist/'
  GIST_URL = "https://gist.github.com/"
  USER_NAME = "sujnesh"
  def new
    @post = Post.new
  end

  def index
    @post = Post.all
  end

  def show
    @post = Post.find_by_id(params[:id])
    commontator_thread_show(@post)
    if @post.gist_id.present?
      @execute_in_colab_url = COLAB_URL + USER_NAME + '/' + @post.gist_id
      @download_url = GIST_URL + USER_NAME + '/' + @post.gist_id
    end
  end

  def update
  end

  def create
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

    def post_params
      params.require(:post).permit(:title, :tagline, :thumbnail, :description, :external_link, :challenge_id, :submission_id)
    end
end

