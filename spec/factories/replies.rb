FactoryGirl.define do
  factory :reply do
    message 'My name is Jon and I support this rating.'
    rating
    user
  end
end
