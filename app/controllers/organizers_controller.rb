class OrganizersController < ApplicationController
  before_action :authenticate_participant!, except: [:show]
  before_action :set_organizer, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized
  before_action :sanitize_fields_params, only: [:update]

  def show
    @challenges = if policy(@organizer).update?
                    @organizer.challenges
                  else
                    @organizer.challenges.where.not(status_cd: 'draft').where(hidden_challenge: false).where(private_challenge: false)
                  end
  end

  def edit; end

  def create
    @organizer = Organizer.new(organizer_params)
    authorize @organizer

    if @organizer.save
      if current_participant.admin?
        redirect_to @organizer, notice: "Organizer has been created."
      else
        current_participant.organizers << @organizer
        current_participant.save!
        redirect_to @organizer, notice: "The request to host challenges has been submitted. After review, you will be notified when #{@organizer.organizer} may begin to host challenges."
      end
    else
      flash[:error] = @organizer.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    if @organizer.update(organizer_params)
      redirect_to @organizer, notice: 'Hosting organizer was successfully updated.'
    else
      flash[:error] = @organizer.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @organizer.destroy
    redirect_to organizers_url, notice: 'Hosting organizer was successfully destroyed.'
  end

  def clef_email
    @organizer = Organizer.friendly.find(params[:organizer_id])
    authorize @organizer
    @participant = Participant.friendly.find(params[:participant_id])
    if @participant.clef_email
      @participant.update(clef_email: false)
    else
      @participant.update(clef_email: true)
    end
    redirect_to organizer_members_path(@organizer)
  end

  def remove_image
    @organizer = Organizer.friendly.find(params[:organizer_id])
    @organizer.remove_image_file!
    @organizer.save
    redirect_to edit_organizer_path(@organizer), notice: 'Image removed.'
  end

  def regen_api_key
    @organizer = Organizer.friendly.find(params[:organizer_id])
    authorize @organizer
    @organizer.api_key = @organizer.generate_api_key
    @organizer.save!
    redirect_to edit_organizer_path(@organizer), notice: 'API Key regenerated.'
  end

  private

  def sanitize_fields_params
    $coords_x = 0
    $coords_y = 0
    $coords_w = 0
    $coords_h = 0

    $coords_x = params[:organizer][:coords_x]
    $coords_y = params[:organizer][:coords_y]
    $coords_w = params[:organizer][:coords_w]
    $coords_h = params[:organizer][:coords_h]
  end

  def set_organizer
    @organizer = Organizer.friendly.find(params[:id])
    authorize @organizer
  end

  def organizer_params
    params
        .require(:organizer)
        .permit(
          :organizer,
          :address,
          :description,
          :approved,
          :organizer_id,
          :status,
          :tagline,
          :image_file,
          :clef_organizer,
          :coords_x,
          :coords_y,
          :coords_w,
          :coords_h,
          clef_tasks_attributes: [
            :id,
            :_delete,
            :task
          ])
  end
end
