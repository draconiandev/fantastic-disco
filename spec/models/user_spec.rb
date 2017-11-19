# frozen_string_literal: true

describe User, type: :model do
  let(:user) { create :user }

  it 'has a valid factory' do
    expect(create(:user)).to be_valid
  end

  context 'with callbacks' do
    it { expect(user).to callback(:generate_account_number).before(:create) }
  end

  context 'with ActiveRecord databases' do
    it { expect(user).to have_db_column(:username).of_type(:string).with_options(null: false, default: '') }
    it { expect(user).to have_db_column(:email).of_type(:string).with_options(null: false, default: '') }
    it { expect(user).to have_db_column(:first_name).of_type(:string).with_options(null: false, default: '') }
    it { expect(user).to have_db_column(:last_name).of_type(:string).with_options(null: false, default: '') }
    it { expect(user).to have_db_column(:mobile_number).of_type(:string).with_options(null: false, default: '') }
    it { expect(user).to have_db_column(:mobile_verified).of_type(:boolean).with_options(null: false, default: false) }
    it { expect(user).to have_db_column(:account_number).of_type(:string).with_options(null: false) }
    it { expect(user).to have_db_index(:account_number).unique }
    it { expect(user).to have_db_index(:confirmation_token).unique }
    it { expect(user).to have_db_index(:email).unique }
    it { expect(user).to have_db_index(:mobile_number).unique }
    it { expect(user).to have_db_index(:reset_password_token).unique }
    it { expect(user).to have_db_index(:unlock_token).unique }
    it { expect(user).to have_db_index(:username).unique }
  end

  context 'with ActiveRecord Associations' do
    it { expect(user).to have_one(:current_address).dependent(:destroy) }
    it { expect(user).to have_one(:permanent_address).dependent(:destroy) }
  end

  context 'with ActiveModel validations' do
    # Presence Validations
    it { expect(user).to validate_presence_of(:first_name) }
    it { expect(user).to validate_presence_of(:last_name) }
    it { expect(user).to validate_presence_of(:email) }
    it { expect(user).to validate_presence_of(:username) }
    it { expect(user).to validate_presence_of(:mobile_number) }
    # Uniqueness Validations
    it { expect(user).to validate_uniqueness_of(:email).case_insensitive }
    it { expect(user).to validate_uniqueness_of(:username).case_insensitive }
    it { expect(user).to validate_uniqueness_of(:mobile_number).case_insensitive }
    it { expect(user).to validate_uniqueness_of(:account_number).case_insensitive }
    # Length Validations
    it { expect(user).to validate_length_of(:mobile_number).is_equal_to(10) }
    it { expect(user).to validate_length_of(:username).is_at_least(4).is_at_most(40) }
    # Format Validations
    it { expect(user).to allow_value('Ramesh').for(:first_name) }
    it { expect(user).not_to allow_value('123').for(:first_name) }
    it { expect(user).not_to allow_value('123Abc').for(:first_name) }
    it { expect(user).not_to allow_value('Abc@ Asd').for(:first_name) }
    it { expect(user).to allow_value('Suresh').for(:last_name) }
    it { expect(user).not_to allow_value('123').for(:last_name) }
    it { expect(user).not_to allow_value('123Abc').for(:last_name) }
    it { expect(user).not_to allow_value('Abc@ Asd').for(:last_name) }
    it { expect(user).to allow_value('asd@asd.com').for(:email) }
    it { expect(user).not_to allow_value('asdasd.com').for(:email) }
    it { expect(user).to allow_value('pavan1611').for(:username) }
    it { expect(user).to allow_value('pavan_1611').for(:username) }
    it { expect(user).to allow_value('pavan_90_1611').for(:username) }
    it { expect(user).not_to allow_value('_pavan1611').for(:username) }
    it { expect(user).not_to allow_value('pavan1611_').for(:username) }
    it { expect(user).not_to allow_value('_pavan1611_').for(:username) }
    it { expect(user).not_to allow_value('pavan__1611').for(:username) }
  end

  context 'with private instance methods' do
    context 'when creating an account, account number' do
      it { expect(user.account_number).not_to be_nil }
    end
  end
end
