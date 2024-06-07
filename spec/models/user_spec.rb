# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }

    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:nickname) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:birthday) }

    it { should validate_uniqueness_of(:nickname).case_insensitive }
  end

  describe 'model methods' do
    let!(:users) { create_list(:user, 2) }
    let(:relationship) { build(:relationship, follower: users[0], followed: users[1]) }

    it 'should follow a user' do
      expect(users[1].following?(users[0])).to be_falsey
      users[1].follow(users[0])
      expect(users[1].following?(users[0])).to be_truthy
      expect(users[0].followers.include?(users[1])).to be_truthy
    end

    it 'should unfollow a user' do
      users[0].follow(users[1])
      users[0].unfollow(users[1])
      expect(users[0].following?(users[1])).to be_falsey
    end
  end
end
