class DatasetFoldersController < ApplicationController
  before_action :authenticate_participant!
  before_action :set_dataset_folder, only: [:edit, :update, :destroy]
  before_action :set_challenge
  before_action :set_challenge_rounds, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :set_vote, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :set_follow, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :check_participation_terms

  def new
    @dataset_folder = @challenge.dataset_folders.new
    authorize @dataset_folder
  end

  def create
    @dataset_folder = @challenge.dataset_folders.new(dataset_folder_params)

    validate_aws_credentials

    if @dataset_folder.errors.none? && @dataset_folder.save
      redirect_to helpers.challenge_dataset_files_path(@challenge),
                  notice: 'Dataset folder was successfully created.'
    else
      flash[:error] = @dataset_folder.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit; end

  def update
    @dataset_folder.assign_attributes(dataset_folder_params)

    validate_aws_credentials

    if @dataset_folder.errors.none? && @dataset_folder.save
      redirect_to helpers.challenge_dataset_files_path(@challenge), notice: 'Dataset folder was successfully updated.'
    else
      flash[:error] = @dataset_folder.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @dataset_folder.destroy
    redirect_to helpers.challenge_dataset_files_path(@challenge), notice: "Dataset folder #{@dataset_folder.title} was deleted."
  end

  private

  def set_dataset_folder
    @dataset_folder = DatasetFolder.find(params[:id])
    authorize @dataset_folder
  end

  def set_challenge
    @challenge      = Challenge.friendly.find(params[:challenge_id])
    @meta_challenge = Challenge.includes(:organizers).friendly.find(params[:meta_challenge_id]) if params.has_key?('meta_challenge_id')
  end

  def set_challenge_rounds
    @challenge_rounds = @challenge.challenge_rounds.started
  end

  def set_vote
    @vote = @challenge.votes.where(participant_id: current_participant.id).first if current_participant.present?
  end

  def set_follow
    @follow = @challenge.follows.where(participant_id: current_participant.id).first if current_participant.present?
  end

  def check_participation_terms
    challenge = @challenge
    challenge = @meta_challenge if @meta_challenge.present?

    unless policy(challenge).has_accepted_participation_terms?
      redirect_to [challenge, ParticipationTerms.current_terms]
      return
    end

    unless policy(challenge).has_accepted_challenge_rules?
      redirect_to [challenge, challenge.current_challenge_rules]
      nil
    end
  end

  def dataset_folder_params
    params
      .require(:dataset_folder)
      .permit(
        :title,
        :description,
        :directory_path,
        :aws_access_key,
        :aws_secret_key,
        :bucket_name,
        :region,
        :aws_endpoint,
        :visible,
        :evaluation
      )
  end

  def validate_aws_credentials
    result = Aws::FetchDatasetFolderService.new(dataset_folder: @dataset_folder).call

    @dataset_folder.errors.add(:base, result.value) if result.failure?
  end
end
