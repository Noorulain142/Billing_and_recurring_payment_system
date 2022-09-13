require 'rails_helper'
RSpec.describe Plan, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:subscriptions).dependent(:destroy) }
    it { is_expected.to have_many(:users).dependent(:destroy) }
    it { is_expected.to have_many(:features).dependent(:destroy) }
  end

  describe 'validations' do
    context 'positive validations' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:monthly_fee) }
      it { is_expected.to validate_numericality_of(:monthly_fee).only_integer.is_greater_than(0) }
    end

    context 'negative validations' do
      it 'is not valid without plan_name' do
        plan = build(:plan, :blank_plan_name)
        expect(plan).to_not be_valid
      end
      it 'is not valid without plan_monthly_fee' do
        plan = build(:plan, :blank_plan_monthly_fee)
        expect(plan).to_not be_valid
      end
      it 'is not valid with less than zero value of plan monthly_fee' do
        plan = build(:plan, :less_than_zero_monthly_fee)
        expect(plan).to_not be_valid
      end
    end
  end

end
