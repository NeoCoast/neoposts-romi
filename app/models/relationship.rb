# frozen_string_literal: true

class Relationship < ApplicationRecord
  validates :follower_id, presence: true, uniqueness: { scope: :followed_id }
  validates :followed_id, presence: true, uniqueness: { scope: :follower_id }

  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'
end
