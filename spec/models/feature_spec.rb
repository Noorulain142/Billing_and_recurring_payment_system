require 'rails_helper'

RSpec.describe Feature, type: :model do
  let(:user1) {create(:user)}
  let(:plan1) {create(:plan)}

  describe 'associations' do
    it { is_expected.to belong_to(:plan) }
  end

  context 'validations' do
    # byebug
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:unit_price) }
    it { is_expected.to validate_presence_of(:max_unit_limit) }
    it { is_expected.to validate_presence_of(:usage_value) }
    it { is_expected.to validate_numericality_of(:max_unit_limit).only_integer.is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:usage_value).only_integer.is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:unit_price).only_integer.is_greater_than(0) }
    it { is_expected.to validate_numericality_of(:code).only_integer.is_greater_than(0) }
  end

  describe '#over_use' do
    it 'should return the overuse of feature' do
      feature = create(:feature)
      expect(feature.over_use).to  eq(1)
    end
  end

end
