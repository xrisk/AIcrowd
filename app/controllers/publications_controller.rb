class PublicationsController < InheritedResources::Base
  before_action :authenticate_participant!, except: [:show, :index]
  before_action :set_publication, only: [:show]

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

  private

  def set_publication
    @publication = Publication.friendly.find(params[:id])
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
      :venue
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

