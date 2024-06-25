# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'validations' do
    subject { build(:like_a_post) }

    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:likable_id) }

    it { should validate_uniqueness_of(:likable_id).scoped_to(:user_id) }
    it { should validate_uniqueness_of(:user_id).scoped_to(:likable_id) }
  end
end
