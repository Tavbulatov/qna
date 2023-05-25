FactoryBot.define do
  factory :answer do
    association :question
    body { 'MyText' }
    author factory: :user

    trait :invalid do
      body { nil }
    end

    trait :with_file do
      after(:build) do |answer|
        answer.files.attach(io: File.open(Rails.root.join('spec', 'rails_helper.rb')), filename: 'rails_helper.rb', content_type: 'application/ruby')
      end
    end

    factory :answer_with_file, traits: [:with_file]
  end
end
