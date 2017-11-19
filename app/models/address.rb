# frozen_string_literal: true

class Address < ApplicationRecord
  extend Enumerize

  belongs_to :user

  validates :address_line_1, :city, :state, :country, :pincode, presence: true

  enumerize :state, in: YAML.load_file(Rails.root.join('config', 'states.yml'))
end
