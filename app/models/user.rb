# frozen_string_literal: true

class User < ApplicationRecord
  has_one :permanent_address, class_name: 'Address', dependent: :destroy
  has_one :current_address, class_name: 'Address', dependent: :destroy
  has_one :user_document, dependent: :destroy

  validates :first_name, :last_name, :email, :mobile_number, presence: true
  validates :email, :mobile_number, :username, :account_number, uniqueness: { case_sensitive: false }
  validates :mobile_number, length: { is: 10 },
                            format: { with: /[789]\d{9}/i, message: 'should start with 7, 8, or 9' }

  # At least one alphabetic character (the [a-z] in the middle).
  # Does not begin or end with an underscore (the (?!_) and (?<!_) at the beginning and end.
  # May have any number of numbers, letters, or underscores before and after the alphabetic character,
  # but every underscore must be separated by at least one number or letter (the rest).
  validates :username, length: { in: 4..40 },
                       format: { with:    /\A(?!_)(?:[a-z0-9]_?)*[a-z](?:_?[a-z0-9])*(?<!_)\z/i,
                                 message: 'only alphabets, digits and underscores are allowed' }

  validates :first_name, :last_name, format: { with: /\A[a-zA-Z. ]*\z/, message: 'please use only English Alphabets' }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :lockable,
    :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  # Before creating the account for the user, generate an account number
  before_create :generate_account_number

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
end
