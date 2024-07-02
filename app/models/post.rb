# frozen_string_literal: true

class Post < ApplicationRecord
  validates :title, :body, presence: true

  before_create :set_post_datetime

  belongs_to :user

  has_one_attached :image

  has_many :comments, as: :commentable, dependent: :destroy

  has_many :likes, as: :likable, dependent: :destroy

  scope :order_by_param, lambda { |order_param|
    case order_param
    when 'most_liked'
      order(likes_count: :desc)
    when 'trending'
      order(Arel.sql('likes_count / EXP(((EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - published_at) ))/ 86400) / 4) DESC'))
    else
      order(published_at: :desc)
    end
  }

  private

  def set_post_datetime
    self.published_at = DateTime.now
  end
end
