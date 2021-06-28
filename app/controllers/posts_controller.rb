class PostsController < InheritedResources::Base
  before_action :authenticate_participant!, except: [:show, :index]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :set_my_challenges, only: [:new, :edit, :update, :create]

  def new
    @post = Post.new
    @post.participant_id = current_participant.id
    if params[:challenge].present?
      @post.challenge = Challenge.friendly.find(params[:challenge])
    end
    if params[:submission].present?
      @post.submission = Submission.find_by_id(params[:submission])
    end
  end

  def set_post
    @post = Post.friendly.find(params[:id])
  end

  def set_my_challenges
    all_challenges = ChallengeParticipant.where(participant_id: current_participant.id)
    meta_challenges = Challenge.where(id: all_challenges.pluck(:challenge_id), meta_challenge: true)
    @my_challenges = all_challenges.map(&:challenge).collect {|c| [ c.challenge, c.id] }
    meta_challenges.each do |meta_challenge|
      @my_challenges += meta_challenge.problems.collect{|c| [c.challenge, c.id] } if meta_challenges.present?
    end
    if params[:challenge].present?
      challenge = Challenge.friendly.find(params[:challenge])
      if !@my_challenges.include?([challenge.challenge, challenge.id])
        @my_challenges.push([challenge.challenge, challenge.id])

        if challenge.meta_challenge?
          @my_challenges += challenge.problems.collect {|c| [ c.challenge, c.id] }
        end
      end
    end
  end

  def index
    if params[:private].present?
      @post = Post.all.where(private: true).limit(30).includes(:participant, :challenge)
      @private_checked = true
    else
      @post = Post.all.where(private: false).limit(30).includes(:participant, :challenge)
    end
  end

  def show
    @execute_in_colab_url = @post.execute_in_colab_url
    @download_notebook_url = @post.download_notebook_url
    @post.record_page_view
    unless @post.external_link.present? && @post.external_link.include?("https://colab.research.google.com")
      @external_link = @post.external_link
    end
    commontator_thread_show(@post)

    authorize @post
  end

  def update
    @post.update(post_params)

    if params["post"]["colab_link"].present? && params["post"]["colab_link"].include?("https://colab.research.google.com")
      if params["post"]["notebook_s3_url"].blank? && (params["post"]["colab_link"] != @post.colab_link)
        flash[:error] = "There was some issue in fetching the colab notebook. Please try again."
        render :edit and return
      end
    end

    if @post.thumbnail.blank?
      @post.thumbnail = @post.get_random_thumbnail
    end

    authorize @post

    if @post.save
      update_post_categories if params["post"]["category_names"].present?
      redirect_to(notebooks_challenge_path(@post.challenge), notice: "The contribution has been added successfully!")
    else
      flash[:error] = t(@post.errors[:base])
      render :new
    end
  end

  def create
    if params["post"]["colab_link"].present? && params["post"]["colab_link"].include?("https://colab.research.google.com")
      if params["post"]["notebook_s3_url"].blank?
        flash[:error] = "There was some issue in fetching the colab notebook. Please try again."
        @post = Post.new(post_params)
        render :new and return
      end
    end

    if params["post"]["description"].size < 50 && params["post"]["notebook_s3_url"].blank?
      flash[:error] = "Please keep the description to a minimum of 50 characters or upload a colab notebook."
      @post = Post.new(post_params)
      render :new and return
    end

    @post = Post.new(post_params)

    @post.participant = current_participant
    if @post.thumbnail.blank?
      @post.thumbnail = @post.get_random_thumbnail
    end

    authorize @post

    if @post.save
      update_post_categories if params["post"]["category_names"].present?
      redirect_to(notebooks_challenge_path(@post.challenge), notice: "The contribution has been added successfully!")
    else
      flash[:error] = @post.errors
      render :new
    end
  end

  def destroy
    authorize @post
    challenge = @post.challenge
    @post.destroy
    redirect_to(notebooks_challenge_path(challenge), notice: "The contribution was deleted successfully!")
  end

  def validate_colab_link
    url = params[:colab_link]
    return unless url.include?("colab.research.google.com")
    result = Notebooks::NotebookService.new(url).call

    unless result.is_a?(Hash)
      render json: {}, status: 422
      return
    end

    render json: result, status: 200
  end

  def validate_notebook
    unless File.extname(params[:post][:notebook_file].original_filename) == ".ipynb"
      render json: {}, status: 422
      return
    end
    result = Notebooks::NotebookFileService.new(params[:post][:notebook_file]).call

    unless result.is_a?(Hash)
      render json: {}, status: 422
      return
    end

    render json: result, status: 200
  end

  private

    def post_params
      params.require(:post).permit(:id, :title, :tagline, :thumbnail, :description, :external_link, :challenge_id, :submission_id, :colab_link, :notebook_file_path, :notebook_s3_url, :notebook_html, :gist_id, :private, :gist_username)
    end

    # def remove_notebook(post)
    #   post.gist_id = nil
    #   post.notebook_s3_url = nil
    #   post.notebook_html = nil
    #   if post.external_link.present? && post.external_link.include?("colab.research.google.com/drive/")
    #     post.external_link = nil
    #   end
    #   post.save!
    #   post
    # end

    def update_post_categories
      @post.category_posts.destroy_all if @post.category_posts.present?
      params[:post][:category_names].reject(&:empty?).each do |category_name|
        category = Category.find_or_create_by(name: category_name)
        if category.save
          @post.category_posts.create!(category_id: category.id)
        else
          @post.errors.messages.merge!(category.errors.messages)
        end
      end
    end
end

