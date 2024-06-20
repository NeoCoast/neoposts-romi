# frozen_string_literal: true

class Comment < ApplicationRecord
  validates :content, presence: true

  belongs_to :commentable, polymorphic: true

  belongs_to :user

  has_many :comments, as: :commentable, dependent: :destroy

  has_many :likes, as: :likable, dependent: :destroy
end
