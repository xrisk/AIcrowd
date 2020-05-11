module Api
  module V1
    module Challenges
      class DatasetFilesController < Api::V1::BaseController
        before_action :auth_by_participant_api_key
        before_action :set_challenge, only: [:create, :update, :destroy]
        before_action :set_dataset_file, only: [:update, :destroy]

        def create
          dataset_file = @challenge.dataset_files.new(dataset_file_params)

          if dataset_file.save
            render json: Api::V1::DatasetFileSerializer.new(dataset_file: dataset_file).serialize, status: :created
          else
            render json: { error: dataset_file.errors.full_messages.to_sentence }, status: :unprocessable_entity
          end
        end

        def update
          if @dataset_file.update(dataset_file_params)
            render json: Api::V1::DatasetFileSerializer.new(dataset_file: @dataset_file).serialize, status: :ok
          else
            render json: { error: @dataset_file.errors.full_messages.to_sentence }, status: :unprocessable_entity
          end
        end

        def destroy
          @dataset_file.destroy!
          head :ok
        end

        private

        def set_challenge
          @challenge = Challenge.friendly.find(params[:challenge_id])

          authorize @challenge, :edit?
        end

        def set_dataset_file
          @dataset_file = @challenge.dataset_files.find(params[:id])
        end

        def dataset_file_params
          params.permit(
            :seq,
            :title,
            :description,
            :dataset_file_s3_key,
            :evaluation,
            :hosting_location,
            :external_url,
            :visible,
            :external_file_size
          )
        end
      end
    end
  end
end
