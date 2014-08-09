FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "test.user#{n}@example.com" }
    password 'password'
    password_confirmation 'password'
  end
end
