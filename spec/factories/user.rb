# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { Faker::Internet.password }
    nickname { Faker::Internet.unique.username }
    first_name { Faker::Name.first_name.gsub(/[^a-zA-Z\.]/, '') }
    last_name { Faker::Name.last_name.gsub(/[^a-zA-Z\.]/, '') }
    birthday { Faker::Date.between(from: '1970-09-23', to: '2023-09-25') }
  end
end
