class PublicationsController < InheritedResources::Base
  before_action :set_publication, only: [:show]
  before_action :set_filters, only: [:all]

  def new
  end

  def index
    params[:page] ||= 1
    @publications = Publication.paginate(page: params[:page], per_page: 10)
  end

  def show
  end

  def update
  end

  def create
    @publication = Publication.new(publication_params)
    if @publication.save
      redirect_to(publications_path, notice: "The publication has been added successfully!")
    else
      flash[:error] = @publication.errors
      render :new
    end
  end

  def all
    @publications     = Publications::FilterService.new(params).call
    @publications     = @publications.per_page_kaminari(params[:page]).per(18)
  end

  private

  def set_publication
    @publication = Publication.friendly.find(params[:id])
  end

  def set_filters
    @categories = Category.where(id: CategoryPublication.all.pluck(:category_id))
    @years      = Publication.all.pluck(:publication_date).map(&:year)
    @venues     = PublicationVenue.all.pluck(:short_name)
  end

  def publication_params
    params.require(:publication).permit(:id,
     :title,
     :thumbnail,
     :description,
     :abstract,
     :challenge_id,
     :publication_date,
     :no_of_citations,
     :aicrowd_contributed,
     :sequence,
     :cite,
     venues_attributes:[
      :id,
      :venue,
      :short_name
     ],
     authors_attributes:[
      :id,
      :name,
      :participant_id,
      :sequence
     ],
     external_links_attributes:[
      :id,
      :name,
      :link,
      :icon
     ],
     categories_attributes:[
      :id,
      :name
     ]
     )
  end

end

