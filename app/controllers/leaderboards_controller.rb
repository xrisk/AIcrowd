class LeaderboardsController < ApplicationController
  before_action :authenticate_participant!,
                except: :index
  before_action :set_challenge
  respond_to :js, :html

  def index
    @current_round = current_round
    @post_challenge = true if @challenge.completed? && params[:post_challenge] == "true"

    current_round_id = if @current_round.blank?
                         0
                       else
                         @current_round.id
                       end
    @leaderboards = if @post_challenge == 'on'
                      policy_scope(OngoingLeaderboard)
                          .where(challenge_round_id: current_round_id)
                          .page(params[:page])
                          .per(10)
                          .order(:seq)
                    else
                      policy_scope(Leaderboard)
                          .where(challenge_round_id: current_round_id)
                          .page(params[:page])
                          .per(10)
                          .order(:seq)
                    end

    if @challenge.challenge == "NeurIPS 2019 : Disentanglement Challenge"
      @leaderboards = DisentanglementLeaderboard
                          .where(challenge_round_id: @current_round)
                          .page(params[:page])
                          .per(10)
                          .order(:row_num)
    end
  end

  def submission_detail
    leaderboard  = Leaderboard.find(params[:leaderboard_id])
    @leaderboard = @challenge.leaderboards
    @submissions = Submission.where(
      participant_id:     params[:participant_id],
      challenge_id:       params[:challenge_id],
      challenge_round_id: leaderboard.challenge_round_id)
      .order(created_at: :desc)
    render js: concept(
      Leaderboard::Cell,
      @leaderboard,
      challenge:   @challenge,
      submissions: @submissions).call(:insert_submissions)
  end

  private

  def set_challenge
    @challenge = Challenge.friendly.find(params[:challenge_id])
  end

  def current_round
    if params[:challenge_round_id].present?
      ChallengeRound.find(params[:challenge_round_id].to_i)
    else
      @challenge.challenge_rounds.where(active: true).first
    end
  end
end
