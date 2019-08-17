require 'rails_helper'

RSpec.describe TeamMember, type: :model do

  it "is valid with valid attributes" do
    expect(create :team_member).to be_valid
  end

  it "is not valid with repeated seq" do
    expect(create :team_member, seq: 0).to be_valid
    expect(build :team_member, seq: 0).to_not be_valid
  end

  it "is not valid without a name" do
    expect(build :team_member, name: nil).to_not be_valid
  end

  it "is not valid without a title" do
    expect(build :team_member, title: nil).to_not be_valid
  end

  it "is not valid without a section" do
    expect(build :team_member, section: nil).to_not be_valid
  end

  it "is valid without a description" do
    expect(build :team_member, description: nil).to be_valid
  end

end
