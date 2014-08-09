FactoryGirl.define do
  factory :rating do
    dimension 'hairiness'
    comment 'Boy, is he a hairy one!'
    rater 'anonymous coward'
    stars 7.5
  end
end
