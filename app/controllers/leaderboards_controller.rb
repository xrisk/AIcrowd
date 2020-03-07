class LeaderboardsController < ApplicationController
  before_action :authenticate_participant!, except: :index
  before_action :set_challenge, only: [:index, :export]
  before_action :set_current_round, only: [:index, :export]

  respond_to :js, :html

  def index
    @vote             = @challenge.votes.where(participant_id: current_participant.id).first if current_participant.present?
    @follow           = @challenge.follows.where(participant_id: current_participant.id).first if current_participant.present?
    @challenge_rounds = @challenge.challenge_rounds.started
    @post_challenge = true if @challenge.completed? && params[:post_challenge] == "true"

    @leaderboards = if @challenge.challenge == "NeurIPS 2019 : Disentanglement Challenge"
      DisentanglementLeaderboard
        .where(challenge_round_id: @current_round)
        .page(params[:page])
        .per(10)
        .order(:row_num)
    elsif @post_challenge
      policy_scope(OngoingLeaderboard)
        .where(challenge_round_id: @current_round&.id.to_i)
        .page(params[:page])
        .per(10)
        .order(:seq)
    else
      policy_scope(Leaderboard)
        .where(challenge_round_id: @current_round&.id.to_i)
        .page(params[:page])
        .per(10)
        .order(:seq)
    end
  end

  def export
    authorize @challenge, :export?

    @leaderboards = Leaderboard
      .where(challenge_round_id: params[:leaderboard_export_challenge_round_id].to_i)
      .order(:seq)

    csv_data = Leaderboards::CSVExportService.new(leaderboards: @leaderboards).call.value

    send_data csv_data,
              type:     'text/csv',
              filename: "#{@challenge.challenge.to_s.parameterize.underscore}_leaderboard_export.csv"
  end

  private

  def set_challenge
    @challenge = Challenge.friendly.find(params[:challenge_id])
  end

  def set_current_round
    @current_round = if params[:challenge_round_id].present?
      @challenge.challenge_rounds.find(params[:challenge_round_id].to_i)
    else
      @challenge.active_round
    end
  end
end
