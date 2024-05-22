# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable

  has_one_attached :profile_picture

  has_many :posts, dependent: :destroy

  validates :email, :password, :nickname, :first_name, :last_name, :birthday, presence: true
  validates :nickname, uniqueness: { case_sensitive: false }
  validates :first_name, :last_name, format: { with: /\A[a-zA-Z\.]+\z/, message: 'only allows letters' }
end
