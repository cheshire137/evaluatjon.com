class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :replies

  before_save :ensure_auth_token

  def as_json options={}
    super(only: [:email, :id]).merge(options)
  end

  def ensure_auth_token
    self.auth_token ||= generate_auth_token
  end

  def reset_auth_token
    self.auth_token = generate_auth_token
    save
  end

  private

  def generate_auth_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(auth_token: token).first
    end
  end
end
