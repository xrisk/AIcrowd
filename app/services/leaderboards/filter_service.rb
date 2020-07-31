module Leaderboards
  class FilterService
    def initialize(leaderboards: leaderboards, params: params)
      @leaderboards = leaderboards.first&.class&.where(id: leaderboards.ids)
      @params       = params
    end

    def call(filter_by)
      case filter_by
      when 'leaderboard_ids'
        leaderboard_ids
      when 'participant_affiliations'
        participant_affiliations
      when 'participant_countries'
        participant_countries
      end
    end

    private

    # leaderboard filter
    def leaderboard_ids
      ids_array  = []
      ids_array += team_leaderboard_ids if leaderboard_having_submitter?('Team')
      ids_array += participant_leaderboard_ids if leaderboard_having_submitter?('Participant')
      ids_array.uniq
    end

    def team_leaderboard_ids
      leaderboards = @leaderboards
      leaderboards = team_country_leaderboards if @params[:country_name].present?
      leaderboards = team_affiliation_leaderboards(leaderboards) if @params[:affiliation].present?
      leaderboards.ids
    end

    def participant_leaderboard_ids
      leaderboards = @leaderboards
      leaderboards = participant_country_leaderboards if @params[:country_name].present?
      leaderboards = participant_affiliation_leaderboards(leaderboards) if @params[:affiliation].present?
      leaderboards.ids
    end

    def team_country_leaderboards
      @leaderboards.joins(team: :participants).by_country(@params[:country_name])
    end

    def participant_country_leaderboards
      @leaderboards.joins(:participant).by_country(@params[:country_name])
    end

    def participant_affiliation_leaderboards(leaderboards)
      leaderboards.joins(:participant).by_affiliation(@params[:affiliation])
    end

    def team_affiliation_leaderboards(leaderboards)
      leaderboards.joins(team: :participants).by_affiliation(@params[:affiliation])
    end

    # check submitter type
    def leaderboard_having_submitter?(submitter_type)
      @leaderboards&.pluck(:submitter_type)&.include?(submitter_type)
    end

    # set country array
    def participant_countries
      countries  = []
      countries += Country.countries(team_participant_ids) if leaderboard_having_submitter?('Team')
      countries += Country.countries(participant_ids) if leaderboard_having_submitter?('Participant')
      countries.uniq
    end

    # set affiliation array
    def participant_affiliations
      affiliations  = []
      affiliations += Country.affiliations(team_participant_ids) if leaderboard_having_submitter?('Team')
      affiliations += Country.affiliations(participant_ids) if leaderboard_having_submitter?('Participant')
      affiliations.uniq
    end

    # set participant ids
    def participant_ids
      if @params[:action] == 'get_affiliation'
        participant_country_leaderboards.pluck(:submitter_id)
      else
        @leaderboards.where(submitter_type: 'Participant').pluck(:submitter_id)
      end
    end

    def team_participant_ids
      team_ids = if @params[:action] == 'get_affiliation'
                   team_country_leaderboards.pluck(:submitter_id)
                 else
                   @leaderboards.where(submitter_type: 'Team').pluck(:submitter_id)
                  end
      TeamParticipant.where(team_id: team_ids).pluck(:participant_id)
    end
  end
end
