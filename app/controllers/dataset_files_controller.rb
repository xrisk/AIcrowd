class DatasetFilesController < ApplicationController
  include Concerns::DatasetFiles
  include Concerns::ChallengeMasthead
  challenge_masthead_actions [:index, :new, :create, :edit, :update, :destroy]

  before_action :authenticate_participant!
  before_action :set_dataset_file, only: [:destroy, :edit, :update]
  before_action :check_participation_terms
  before_action :set_s3_direct_post, only: [:new, :create, :edit, :update]
  before_action :set_dataset_files, only: :index # from DatasetFilesConcern
  before_action :set_dataset_folders, only: :index # from DatasetFilesConcern

  def index
    if @challenge.clef_task&.use_challenge_dataset_files?
      redirect_to clef_task_task_dataset_files_path(@challenge.clef_task, challenge_id: @challenge.id)
    end
  end

  def new
    @dataset_file = @challenge.dataset_files.new
    authorize @dataset_file
  end

  def create
    @dataset_file = @challenge.dataset_files.new(dataset_file_params)

    validate_aws_credentials

    if @dataset_file.errors.none? && @dataset_file.save
      redirect_to helpers.challenge_dataset_files_path(@challenge),
                  notice: 'Dataset file was successfully created.'
    else
      flash[:error] = @dataset_file.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit; end

  def update
    @dataset_file.assign_attributes(dataset_file_params)

    validate_aws_credentials

    if @dataset_file.errors.none? && @dataset_file.save
      redirect_to helpers.challenge_dataset_files_path(@challenge), notice: 'Dataset file was successfully updated.'
    else
      flash[:error] = @dataset_file.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    if @dataset_file.dataset_file_s3_key.present?
      s3 = Aws::S3::Client.new
      s3.delete_object(key: @dataset_file.dataset_file_s3_key, bucket: ENV['AWS_S3_BUCKET'])
    end
    @dataset_file.destroy
    redirect_to helpers.challenge_dataset_files_path(@challenge), notice: "Dataset file #{@dataset_file.title} was deleted."
  end

  private

  def set_dataset_file
    @dataset_file = DatasetFile.find(params[:id])
    authorize @dataset_file
  end

  def check_participation_terms
    challenge = @challenge
    challenge = @meta_challenge if @meta_challenge.present?

    unless policy(challenge).has_accepted_participation_terms?
      redirect_to [challenge, ParticipationTerms.current_terms]
      return
    end

    unless policy(challenge).has_accepted_challenge_rules?
      redirect_to challenge_challenge_rules_path(challenge)
      nil
    end
  end

  def dataset_file_params
    params
      .require(:dataset_file)
      .permit(
        :seq,
        :description,
        :evaluation,
        :visible,
        :title,
        :file_size,
        :dataset_file_s3_key,
        :hosting_location,
        :external_url,
        :external_file_size,
        :file_path,
        :aws_access_key,
        :aws_secret_key,
        :bucket_name,
        :region
      )
  end

  def set_s3_direct_post
    @s3_direct_post = S3_BUCKET
                      .presigned_post(
                        key:                   "dataset_files/challenge_#{@challenge.id}/#{SecureRandom.uuid}_${filename}",
                        success_action_status: '201',
                        acl:                   'private'
                      )
  end

  def validate_aws_credentials
    return if @dataset_file.hosting_location != 'Own S3'

    result = Aws::FetchDatasetFileService.new(dataset_file: @dataset_file).call

    @dataset_file.errors.add(:base, result.value) if result.failure?
  end
end
