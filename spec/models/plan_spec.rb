require 'rails_helper'
RSpec.describe Plan, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:subscriptions).dependent(:destroy) }
    it { is_expected.to have_many(:users).dependent(:destroy) }
    it { is_expected.to have_many(:features).dependent(:destroy) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:monthly_fee) }
    it { is_expected.to validate_numericality_of(:monthly_fee).only_integer.is_greater_than(0) }
  end

end
