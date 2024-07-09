# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable

  include DeviseTokenAuth::Concerns::User

  validates :email, :nickname, :first_name, :last_name, :birthday, presence: true
  validates :nickname, uniqueness: { case_sensitive: false }
  validates :first_name, :last_name, format: { with: /\A[a-zA-Z\.]+\z/, message: 'only allows letters' }

  has_one_attached :profile_picture

  has_many :posts, dependent: :destroy

  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy

  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships

  has_many :following_posts, through: :following, source: :posts

  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :likable, source_type: 'Post'
  has_many :liked_comments, through: :likes, source: :likable, source_type: 'Comment'

  paginates_per 5

  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def like(likable)
    likes.create(likable:)
  end

  def unlike(likable)
    likes.find_by(likable:)&.destroy
  end

  def liked_posts?(likable)
    liked_posts.include?(likable)
  end

  def liked_comments?(likable)
    liked_comments.include?(likable)
  end

  scope :search_by_param, lambda { |search_param|
    if search_param.present?
      where('nickname ILIKE ? OR first_name ILIKE ? OR last_name ILIKE ?',
            "%#{search_param}%", "%#{search_param}%", "%#{search_param}%")
    end
  }
end
