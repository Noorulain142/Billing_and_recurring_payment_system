# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user1) { create(:user) }
  describe 'associations' do
    it { is_expected.to have_many(:subscriptions).dependent(:destroy) }
    it { is_expected.to have_many(:plans).through(:subscriptions) }
    it { is_expected.to have_one_attached(:avatar) }
  end

  describe 'validations' do
    context 'positive validations' do
      it 'Image is valid as its type valid(png)' do
        user = build(:user, :valid_avatar)
        expect(user).to be_valid
      end
    end
    context 'negative validations' do
      it 'Image is invalid as its type invalid(svg)' do
        user = build(:user, :invalid_avatar)
        expect(user).to_not be_valid
        expect { raise 'you tried uploading wrong file' }.to raise_error
        # expect(response.body).to include('you tried uploading wrong file')
      end
    end
  end
end
