# frozen_string_literal: true

class User < ApplicationRecord
  has_one :permanent_address, class_name: 'Address', dependent: :destroy
  has_one :current_address, class_name: 'Address', dependent: :destroy
  has_one :user_document, dependent: :destroy

  validates :first_name, :last_name, :email, :mobile_number, presence: true
  validates :email, :mobile_number, :account_number, uniqueness: { case_sensitive: false }
  validates :mobile_number, length: { is: 10 },
                            format: { with: /[789]\d{9}/i, message: 'should start with 7, 8, or 9' }

  # At least one alphabetic character (the [a-z] in the middle).
  # Does not begin or end with an underscore (the (?!_) and (?<!_) at the beginning and end.
  # May have any number of numbers, letters, or underscores before and after the alphabetic character,
  # but every underscore must be separated by at least one number or letter (the rest).
  validates :username, length: { in: 4..40 },
                       format: { with:    /\A(?!_)(?:[a-z0-9]_?)*[a-z](?:_?[a-z0-9])*(?<!_)\z/i,
                                 message: 'only alphabets, digits and underscores are allowed' },
                       uniqueness: { case_sensitive: false },
                       allow_blank: true

  validates :first_name, :last_name, format: { with: /\A[a-zA-Z. ]*\z/, message: 'please use only English Alphabets' }

  attr_accessor :login
  attr_reader :otp

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :lockable,
    :recoverable, :rememberable, :trackable, :validatable, :timeoutable,
    authentication_keys: [:login]

  # Before creating the account for the user, generate an account number
  before_create :generate_account_number
  # After creating the account, generate a OTP and send it to the user
  after_create :generate_and_send_otp

  # Enables the authentication system to login a user using either account number or username
  # The key should be login instead of username or account_number in the params hash
  # Upon duplicating the hash and deleting the key, returns the value entered by the client
  # Dowcased value is then compared against account number or a username
  # If login key is not present, method checks if account_number or username keys, then finds by
  # those conditions
  # Taken from: https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign-in-using-their-username-or-email-address
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      find_by(['lower(account_number) = :value OR lower(username) = :value', { value: login.downcase }])
    elsif conditions.key?(:account_number) || conditions.key?(:username)
      find_by(conditions.to_hash)
    end
  end

  def docs_uploaded?
    user_document.present?
  end

  private

  # Returns if account number is already present, else continues to generate a token
  def generate_account_number
    return if account_number.present?
    self.account_number = generate_account_number_token
  end

  # SecureRandom.hex(3) gives a 6 character long alphanumeric string which will be upcased
  # before saving. If we want to change the length of account number, change the number here.
  # The character length will be twice the number_of_bytes that we pass in as argument.
  # SecureRandom.hex(3) => "2c1083"
  # SecureRandom.hex(4) => "2bb093ed"
  def generate_account_number_token
    loop do
      token = SecureRandom.hex(3).upcase
      break token unless User.find_by(account_number: token)
    end
  end

  def generate_and_send_otp
    otp = Array.new(6) { rand(10) }.join
    Redis.current.set(id, otp)
    logger.info "OTP: #{otp}"
  end
end
