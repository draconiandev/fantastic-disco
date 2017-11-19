# frozen_string_literal: true

class UserDocument < ApplicationRecord
  belongs_to :user

  validates :pan_number, :pan, :aadhar_number, :aadhar, presence: true
  validates :pan_number, :aadhar_number, :passport_number, uniqueness: { case_sensitive: false }
  validates :pan_number, length: { is: 10 },
                         format: { with: /[a-zA-z]{5}\d{4}[a-zA-Z]{1}/, message: 'not a valid format' }
  validates :aadhar_number, length: { is: 12 },
                            format: { with: /\d{12}/, message: 'must contain only digits' }
  validates :passport_number, length: { is: 8 },
                              format: { with:    /[a-pr-wyA-PR-WY][1-9]\d\s?\d{4}[1-9]/,
                                        message: 'not a valid format' }
end
