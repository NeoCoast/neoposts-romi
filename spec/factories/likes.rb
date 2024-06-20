# frozen_string_literal: true

FactoryBot.define do
  factory :like do
    association :user, factory: :user

    factory :like_a_post do
      association :likable, factory: :post
    end

    factory :like_a_comment do
      association :likable, factory: :comment_of_a_post
    end
  end
end
