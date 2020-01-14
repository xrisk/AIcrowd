class TopicsDigestQuery
  def initialize(participant, start_dttm)
    @participant_id = if participant.is_a?(NullParticipant)
                        0
                      else
                        participant.id
                      end
    @start_dttm = start_dttm.to_s
  end

  def call
    ActiveRecord::Base.connection.select_values(sql)
  end

  def sql
    %[
      SELECT t.id AS id
        FROM email_preferences p,
             follows f,
             topics t
       WHERE f.participant_id = #{@participant_id}
         AND f.participant_id = p.participant_id
         AND f.followable_type = 'Challenge'
         AND t.challenge_id = f.followable_id
         AND t.created_at >= '#{@start_dttm}'
         AND p.email_frequency_cd IN ('daily','weekly')
         AND p.challenges_followed IS TRUE
    ]
  end
end
