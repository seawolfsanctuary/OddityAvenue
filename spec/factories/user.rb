FactoryGirl.define do
  factory :admin, class: Admin::User do |u|
    u.sequence(:email) { |n| "persion#{n}@example.com" }
    u.password "Password123!"
  end
end
