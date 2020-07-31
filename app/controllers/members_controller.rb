class MembersController < ApplicationController
  before_action :authenticate_participant!, except: [:show]
  before_action :set_organizer

  def index
    @challenges = @organizer.challenges
    @members    = @organizer.participants
  end

  def new
    @challenges = @organizer.challenges
    @members    = @organizer.participants
  end

  def create
    participant           = Participant.find_by('lower(email) = ?', strong_params[:email].to_s.downcase)
    participant_organizer = ParticipantOrganizer.new(participant: participant, organizer: @organizer)

    if participant_organizer.save
      flash[:info] = 'Participant added as an Organizer'
    else
      flash[:error] = participant_organizer.errors.full_messages.to_sentence
    end

    redirect_to organizer_members_path(@organizer)
  end

  def destroy
    participant = Participant.friendly.find(params[:id])
    @organizer.participants.destroy(participant)
    redirect_to organizer_members_path(@organizer)
  end

  private

  def strong_params
    params.require(:member).permit(:email)
  end

  def set_organizer
    @organizer = Organizer.friendly.find(params[:organizer_id])
  end
end
