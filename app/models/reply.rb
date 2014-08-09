class Reply < ActiveRecord::Base
  belongs_to :user
  belongs_to :rating

  validates :user, presence: true
  validates :rating, presence: true
  validates :message, presence: true
end
