# frozen_string_literal: true

class Post < ApplicationRecord
  validates :title, :body, presence: true

  before_create :set_post_datetime

  belongs_to :user

  has_one_attached :image

  has_many :comments, as: :commentable, dependent: :destroy

  has_many :likes, as: :likable, dependent: :destroy

  scope :newest_first, -> { order(published_at: :desc) }

  private

  def set_post_datetime
    self.published_at = DateTime.now
  end
end
