# frozen_string_literal: true

class User < ApplicationRecord
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
