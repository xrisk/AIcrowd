module Api
  module V1
    module Challenges
      class DatasetFoldersController < Api::V1::BaseController
        before_action :auth_by_participant_api_key
        before_action :set_challenge, only: [:create, :update, :destroy]
        before_action :set_dataset_folder, only: [:update, :destroy]

        def create
          dataset_folder = @challenge.dataset_folders.new(dataset_folder_params)

          if dataset_folder.save
            render json: Api::V1::DatasetFolderSerializer.new(dataset_folder: dataset_folder).serialize, status: :created
          else
            render json: { error: dataset_folder.errors.full_messages.to_sentence }, status: :unprocessable_entity
          end
        end

        def update
          if @dataset_folder.update(dataset_folder_params)
            render json: Api::V1::DatasetFolderSerializer.new(dataset_folder: @dataset_folder).serialize, status: :ok
          else
            render json: { error: @dataset_folder.errors.full_messages.to_sentence }, status: :unprocessable_entity
          end
        end

        def destroy
          @dataset_folder.destroy!
          head :ok
        end

        private

        def set_challenge
          @challenge = Challenge.friendly.find(params[:challenge_id])

          authorize @challenge, :edit?
        end

        def set_dataset_folder
          @dataset_folder = @challenge.dataset_folders.find(params[:id])
        end

        def dataset_folder_params
          params.permit(
            :title,
            :description,
            :directory_path,
            :aws_access_key,
            :aws_secret_key,
            :bucket_name,
            :region,
            :visible,
            :evaluation
          )
        end
      end
    end
  end
end
