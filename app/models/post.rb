# frozen_string_literal: true

class Post < ApplicationRecord
  validates :title, :body, presence: true

  before_create :set_post_datetime

  belongs_to :user

  has_one_attached :image

  private

  def set_post_datetime
    self.published_at = DateTime.now
  end
end
