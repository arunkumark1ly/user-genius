FactoryBot.define do
  factory :user do
    sequence(:uuid) { |n| 144 + n }
  end
end
