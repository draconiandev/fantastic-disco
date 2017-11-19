# frozen_string_literal: true

class UserDocument < ApplicationRecord
  # Must contain 5 alphabets in the start followed by 4 digits and an alphabet
  PAN_FORMAT = /[a-zA-z]{5}\d{4}[a-zA-Z]{1}/
  # Must be 12 digit long number
  AADHAR_FORMAT = /\d{12}/
  # Must start with an alphabet that is not Q, X or Z, followed by a digit that is not 0
  # There can be an optional space followed by 4 digit long numbers which are not 0
  # Taken from https://marketplace.informatica.com/solutions/validate_indian_passport_regex
  PASSPORT_FORMAT = /[a-pr-wyA-PR-WY][1-9]\d\s?\d{4}[1-9]/

  belongs_to :user

  validates :pan_number, :pan, :aadhar_number, :aadhar, presence: true
  validates :pan_number, :aadhar_number, :passport_number, uniqueness: { case_sensitive: false }
  validates :pan_number, length: { is: 10 },
                         format: { with: PAN_FORMAT, message: 'not a valid format' }
  validates :aadhar_number, length: { is: 12 },
                            format: { with: AADHAR_FORMAT, message: 'must contain only digits' }
  validates :passport_number, length: { is: 8 },
                              format: { with: PASSPORT_FORMAT, message: 'not a valid format' }

  # Upcase the attributes to normalize the values across the table
  before_create :upcase_attrs

  mount_uploader :pan, DocumentUploader
  mount_uploader :aadhar, DocumentUploader
  mount_uploader :passport, DocumentUploader

  private

  def upcase_attrs
    self.pan_number = pan_number.upcase
    self.passport_number = passport_number.upcase
  end
end
