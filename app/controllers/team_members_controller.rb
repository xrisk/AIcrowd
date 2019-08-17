class TeamMembersController < ApplicationController
  def index
    @section_to_member_hash = Hash.new [];
    TeamMember.order(:seq).each { |x| @section_to_member_hash[x.section.upcase] += [x] }
  end
end
