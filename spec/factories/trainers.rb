FactoryGirl.define do
  factory :trainer do
    email { FFaker::Internet.email }
    username { FFaker::Name.name }
    password "password1"
    password_confirmation "password1"
  end
end
