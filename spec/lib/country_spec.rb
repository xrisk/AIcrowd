require 'rails_helper'

describe Country do
  context 'Country and city' do
    let!(:participant) { create :participant, country_cd: 'AU' }

    it 'should return country name by its code' do
      country_name = Country.country_name('IN')
      expect(country_name).to eq('India')
    end

    it 'should return affiliations from participant ids' do
      affiliations = Country.affiliations([participant.id])
      expect(affiliations).to eq([participant.affiliation])
    end

    it 'should return countries of participants' do
      countries = Country.countries([participant.id])
      expect(countries).to eq(['Australia'])
    end
  end
end
