# frozen_string_literal: true

describe Address, type: :model do
  let(:address) { create :address }

  it 'has a valid factory' do
    expect(create(:address)).to be_valid
  end

  context 'with ActiveRecord databases' do
    it { expect(address).to have_db_column(:address_line_1).of_type(:text).with_options(null: false, default: '') }
    it { expect(address).to have_db_column(:address_line_2).of_type(:text) }
    it { expect(address).to have_db_column(:city).of_type(:string).with_options(null: false, default: '') }
    it { expect(address).to have_db_column(:state).of_type(:string).with_options(null: false, default: '') }
    it { expect(address).to have_db_column(:pincode).of_type(:string).with_options(null: false, default: '') }
    it { expect(address).to have_db_column(:country).of_type(:string).with_options(null: false, default: '') }
    it { expect(address).to have_db_column(:user_id).of_type(:uuid) }
    it { expect(address).to have_db_index(:user_id) }
  end

  context 'with ActiveRecord Associations' do
    it { expect(address).to belong_to(:user) }
  end

  context 'with ActiveModel validations' do
    # Presence Validations
    it { expect(address).to validate_presence_of(:address_line_1) }
    it { expect(address).to validate_presence_of(:city) }
    it { expect(address).to validate_presence_of(:state) }
    it { expect(address).to validate_presence_of(:country) }
    it { expect(address).to validate_presence_of(:pincode) }
  end
end
