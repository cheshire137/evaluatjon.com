class Rating < ActiveRecord::Base
  validates :dimension, presence: true
  validates :stars, presence: true, numericality: {greater_than_or_equal_to: 0}
end
