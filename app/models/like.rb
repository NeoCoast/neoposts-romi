# frozen_string_literal: true

class Like < ApplicationRecord
  validates :likable_id, presence: true, uniqueness: { scope: :user_id }
  validates :user_id, presence: true, uniqueness: { scope: :likable_id }

  belongs_to :likable, polymorphic: true, counter_cache: true
  belongs_to :user
end
