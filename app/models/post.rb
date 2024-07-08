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

  scope :by_author, lambda { |author|
    joins(:user).where('users.nickname LIKE ?', "%#{author}%") if author.present?
  }

  scope :by_text, lambda { |text|
    where('title LIKE ? OR body LIKE ?', "%#{text}%", "%#{text}%") if text.present?
  }

  scope :by_published_date, lambda { |published_date|
    return if published_date.blank?

    case published_date
    when 'last_day'
      where('published_at >= ?', 1.day.ago)
    when 'last_week'
      where('published_at >= ?', 1.week.ago)
    when 'last_month'
      where('published_at >= ?', 1.month.ago)
    end
  }

  scope :filter_by, lambda { |author, text, published_date|
    by_author(author).by_text(text).by_published_date(published_date)
  }

  private

  def set_post_datetime
    self.published_at = DateTime.now
  end
end
