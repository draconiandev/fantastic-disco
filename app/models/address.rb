# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :user

  validates :address_line_1, :city, :state, :country, :pincode, presence: true
end
