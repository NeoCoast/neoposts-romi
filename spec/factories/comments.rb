# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.paragraph }
    user

    factory :comment_of_a_post do
      association :commentable, factory: :post
    end

    factory :comment_of_a_comment do
      association :commentable, factory: :comment_of_a_post
    end
  end
end
