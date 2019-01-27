class BlogsController < ApplicationController
  before_action :authenticate_participant!,
    except: [:show,:index]
  before_action :set_blog, only: :show

  def index
    @blogs = policy_scope(Blog)
      .page(params[:page])
      .per(20)
  end

  def show
    if !params[:version]  # don't record page views on history pages
      @blog.record_page_view
    end
  end

  def set_blog
    @blog = Blog.find(params[:id])
    # Randomly select 3 blogs
    @selected_blogs = Blog.where.not(id: @blog.id).order("RANDOM()").sample(3)
    authorize @blog
  end

  private
  def blog_params
    params.require(:blog).permit(:participant_id, :title, :body, :published, :vote_count, :view_count)
  end

end
