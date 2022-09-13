require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user1) {create(:user)}
  describe 'associations' do
    it { is_expected.to have_many(:subscriptions).dependent(:destroy) }
    it { is_expected.to have_many(:plans).through(:subscriptions) }
    it { is_expected.to have_one_attached(:avatar) }
  end

  context 'validations' do

    it 'Image is invalid as its type invalid(svg)' do
      user = build(:user, :invalid_avatar)
      expect(user).to_not be_valid
    end

  end
end
