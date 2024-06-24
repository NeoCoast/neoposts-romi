# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
    user

    trait :commented do
      after(:create) do |post|
        create_list :comment_of_a_post, 2, commentable: post
      end
    end

    trait :liked do
      after(:create) do |post|
        create :like_a_post, likable: post
      end
    end

    trait :liked_and_commented do
      after(:create) do |post|
        create_list :comment_of_a_post, 2, commentable: post
        create :like_a_post, likable: post
      end
    end
  end
end
