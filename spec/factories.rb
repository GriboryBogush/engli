FactoryBot.define do

  factory :user do
    username { Faker::Name.unique.name }
    email { Faker::Internet.email }
    slug { username }
    age { 25 }
    pro { true }
    #encrypted_password { '1234' }
    password { '123456' }
    confirmed_at { Time.now }
  end

  factory :phrase do
    user
    phrase { Faker::Movies::BackToTheFuture.quote }
    translation { "Some translation" }
    category { 1 }
    slug { :phrase }

    trait :invalid do
      phrase { nil }
    end

    trait :update do
      phrase { Faker::Movies::Ghostbusters.quote }
    end
  end

  factory :example do
    user
    phrase
    example { Faker::Movies::BackToTheFuture.quote }

    trait :invalid do
      example { nil }
    end
  end
end
