FactoryBot.define do
  factory :answer do
    association :question
    body { 'MyText' }
    author factory: :user

    trait :invalid do
      body { nil }
    end
  end
end
