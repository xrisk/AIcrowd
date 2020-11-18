class PostsController < InheritedResources::Base

  def new
    @post = Post.new
  end

  def index
    @post = Post.all
  end

  def show
    @post = Post.find_by_id(params[:id])
  end

  def update
  end

  def create
    byebug
    post = Post.new(post_params)
    if params["post"]["notebook_file"].present?
      uploaded_file = params["post"]["notebook_file"]
      notebook_file_path = Rails.root.join('public', 'uploads',uploaded_file.original_filename)
      File.open(notebook_file_path, 'wb'){ |file| file.write(uploaded_file.read)}
      `jupyter nbconvert --to html #{notebook_file_path}`
      html_filename = uploaded_file.original_filename.chomp(File.extname(uploaded_file.original_filename)) + (".html")
      post.notebook_html = File.read(Rails.root.join('public', 'uploads', html_filename)).html_safe
    end
    if post.save
      render :index
    else
      flash[:error] = 'Something went wrong'
      render :new
    end
    byebug
  end

  def destroy
  end

  private

    def post_params
      params.require(:post).permit(:title, :tagline, :thumbnail, :description, :external_link, :challenge_id, :submission_id)
    end
end

