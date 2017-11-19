# frozen_string_literal: true

class Address < ApplicationRecord
  extend Enumerize

  belongs_to :user

  validates :address_line_1, :city, :state, :country, :pincode, presence: true
  validate :valid_pincode

  # Loads the list of states from a yml file and makes sure that the input is
  # included within the list. Can also be used to scoped queries based on the state.
  # Ex: Address.with_state('Karnataka') gives a list of all addresses with Karnataka
  # as the state.
  # Note: scope: true needs to be added as an attribute to get scoped queries feature
  enumerize :state, in: YAML.load_file(Rails.root.join('config', 'states.yml'))

  private

  # Uses MyGov data to check if the entered Pincode exists in the database.
  # You can get the API key and the Resource ID by registering in the following link.
  # https://auth.mygov.in/user/register?destination=oauth2/register/datagovindia
  # In future, the same response can be used to populate the city and state fields if not using Google Places API
  def valid_pincode
    response = Net::HTTP.get(pincode_verification_url)
    data = JSON.parse(response)
    fields = data['records']
    errors.add(:pincode, 'not a valid pincode') if fields.blank?
  end

  def pincode_verification_url
    base_uri = 'https://api.data.gov.in/resource/'
    pincode_api_key = Rails.application.secrets.pincode_api_key
    pincode_resource_id = Rails.application.secrets.pincode_resource_id
    URI("#{base_uri}#{pincode_resource_id}?format=json&api-key=#{pincode_api_key}&filters[pincode]=#{pincode}")
  end
end
