class ChallengeProblemsController < ApplicationController
  before_action :authenticate_participant!
  before_action :set_challenge
  after_action :verify_authorized

  def show
    if request.post?
      if params.has_key?(:challenge_problems)
        create
      elsif params.has_key?(:delete)
        delete(params[:delete].keys[0])
      elsif params.has_key?(:data)
        update(params[:data])
      end
    end
    authorize @challenge.challenge_problems
  end

  private

  def create
    obj = ChallengeProblems.new({
      challenge_id: @challenge.id,
      problem_id: params[:challenge_problems][:problem_id],
      weight: params[:challenge_problems][:weight],
      challenge_round_id: params[:challenge_problems][:challenge_round_id],
      occur_day: params[:challenge_problems][:occur_day]
    })
    authorize obj
    obj.save!
  end

  def delete(problem_id)
    authorize @challenge.challenge_problems
    ChallengeProblems.where(challenge_id: @challenge.id, problem_id: problem_id).destroy_all
  end

  def update(challenge_problems)
    challenge_problems.each do |problem_id, value|
      obj = ChallengeProblems.find_by(challenge_id: @challenge.id, problem_id: problem_id)
      obj.weight = value['weight']
      obj.challenge_round_id = value['challenge_round_id']
      obj.occur_day = value['occur_day']
      authorize obj
      obj.save!
    end
  end

  def set_challenge
    @challenge = Challenge.friendly.find(params[:id])
    @challenge_rounds = @challenge.challenge_rounds
  end
end
