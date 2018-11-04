class User < ApplicationRecord
  ATTRIBUTE_PARAMS = [:name, :email, :password, :password_confirmation].freeze
  ATTRIBUTE_PARAMS_PASSWORD = %i(password password_confirmation).freeze
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  has_many :money, dependent: :destroy

  scope :admins, ->{where admin: true}

  before_save :email_downcase

  attr_reader :remember_token
  attr_accessor :activation_token, :reset_token

  validates :email, presence: true,
    length: {maximum: Settings.user_model.email_maximun},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.user_model.password_minximun}, allow_nil: true

  has_secure_password

  class << self
    def digest string
      cost =
        if ActiveModel::SecurePassword.min_cost
          BCrypt::Engine::MIN_COST
        else
          BCrypt::Engine.cost
        end
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def expenses
    money.expense
  end

  def income
    money.income
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.blank?
    BCrypt::Password.new(digest).is_password? token
  end

  def current_user? current_user
    self == current_user
  end

  def forget
    update_attributes remember_digest: nil
  end

  def amount(range_time)
    money.by_time(range_time).sum(:amount)
  end

  private

  def email_downcase
    email.downcase!
  end
end
