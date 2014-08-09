class Reply < ActiveRecord::Base
  belongs_to :user
  belongs_to :rating

  validates :user, presence: true
  validates :rating, presence: true
  validates :message, presence: true

  def as_json options={}
    super(only: [:rating_id, :message, :created_at, :updated_at, :id]).
        merge(options)
  end
end
