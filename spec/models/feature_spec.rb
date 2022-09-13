require 'rails_helper'

RSpec.describe Feature, type: :model do
  let(:user1) {create(:user)}
  let(:plan1) {create(:plan)}

  describe 'associations' do
    it { is_expected.to belong_to(:plan) }
  end

  describe 'validations' do
    context 'positive validations' do

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

    context 'negative validations' do

      it 'is not valid without feature_name' do
        feature = build(:feature, :blank_feature_name)
        expect(feature).to_not be_valid
      end
      it 'is not valid without feature_code' do
        feature = build(:feature, :blank_feature_code)
        expect(feature).to_not be_valid
      end

      it 'is not valid without feature_unit_price' do
        feature = build(:feature, :blank_feature_unit_price)
        expect(feature).to_not be_valid
      end

      it 'is not valid without feature_max_unit_limit' do
        feature = build(:feature, :blank_feature_max_unit_limit)
        expect(feature).to_not be_valid
      end
      it 'is not valid without feature_usage_value' do
        feature = build(:feature, :blank_feature_usage_value)
        expect(feature).to_not be_valid
      end

      it 'is not valid with less than zero feature_usage_value' do
        feature = build(:feature, :less_than_zero_feature_usage_value)
        expect(feature).to_not be_valid
      end

      it 'is not valid with less than zero value of feature_max_unit_limit' do
        feature = build(:feature, :less_than_zero_feature_max_unit_limit)
        expect(feature).to_not be_valid
      end

      it 'is not valid with less than zero value of feature_unit_price' do
        feature = build(:feature, :less_than_zero_feature_unit_price)
        expect(feature).to_not be_valid
      end

      it 'is not valid with less than zero value of feature_code' do
        feature = build(:feature, :less_than_zero_feature_code)
        expect(feature).to_not be_valid
      end

    end
  end

  describe '#over_use' do
    it 'should return the overuse of feature' do
      feature = create(:feature)
      expect(feature.over_use).to  eq(1)
    end
  end

end
