# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Subscription, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:plan) }
    it { is_expected.to belong_to(:user) }
  end
end
