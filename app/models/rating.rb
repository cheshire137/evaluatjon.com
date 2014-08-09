class Rating < ActiveRecord::Base
  has_many :replies

  validates :dimension, presence: true
  validates :stars, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :rater, presence: true
end
