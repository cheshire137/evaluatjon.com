class Rating < ActiveRecord::Base
  MAX_STARS = 10.freeze
  has_many :replies

  validates :dimension, presence: true
  validates :stars, presence: true,
                    numericality: {greater_than_or_equal_to: 0,
                                   less_than_or_equal_to: MAX_STARS}
  validates :rater, presence: true

  def as_json options={}
    super(include: {replies: {only: [:rating_id, :message, :created_at,
                                     :updated_at, :id]}}).merge(options)
  end
end
