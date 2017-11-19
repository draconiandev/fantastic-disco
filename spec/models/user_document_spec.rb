# frozen_string_literal: true

describe UserDocument, type: :model do
  let(:user_document) { create :user_document }

  it 'has a valid factory' do
    expect(create(:user_document)).to be_valid
  end

  context 'with ActiveRecord databases' do
    it { expect(user_document).to have_db_column(:passport_number).of_type(:string) }
    it { expect(user_document).to have_db_column(:passport).of_type(:string) }
    it { expect(user_document).to have_db_column(:pan_number).of_type(:string).with_options(null: false, default: '') }
    it { expect(user_document).to have_db_column(:pan).of_type(:string).with_options(null: false, default: '') }
    it { expect(user_document).to have_db_column(:aadhar_number).of_type(:string).with_options(null: false, default: '') }
    it { expect(user_document).to have_db_column(:aadhar).of_type(:string).with_options(null: false, default: '') }
    it { expect(user_document).to have_db_index(:aadhar_number).unique }
    it { expect(user_document).to have_db_index(:pan_number).unique }
    it { expect(user_document).to have_db_index(:passport_number).unique }
    it { expect(user_document).to have_db_index(:user_id) }
  end

  context 'with ActiveRecord Associations' do
    it { expect(user_document).to belong_to(:user) }
  end

  context 'with ActiveModel validations' do
    # Presence Validations
    it { expect(user_document).to validate_presence_of(:pan_number) }
    it { expect(user_document).to validate_presence_of(:pan) }
    it { expect(user_document).to validate_presence_of(:aadhar_number) }
    it { expect(user_document).to validate_presence_of(:aadhar) }
    # Uniqueness Validations
    it { expect(user_document).to validate_uniqueness_of(:pan_number).case_insensitive }
    it { expect(user_document).to validate_uniqueness_of(:aadhar_number).case_insensitive }
    it { expect(user_document).to validate_uniqueness_of(:passport_number).case_insensitive }
    # Length Validations
    it { expect(user_document).to validate_length_of(:pan_number).is_equal_to(10) }
    it { expect(user_document).to validate_length_of(:aadhar_number).is_equal_to(12) }
    it { expect(user_document).to validate_length_of(:passport_number).is_equal_to(8) }
    # Format Validations
    it { expect(user_document).to allow_value('p1352371').for(:passport_number) }
    it { expect(user_document).to allow_value('P1352371').for(:passport_number) }
    it { expect(user_document).not_to allow_value('1P352371').for(:passport_number) }
    it { expect(user_document).not_to allow_value('Q1352371').for(:passport_number) }
    it { expect(user_document).not_to allow_value('X1352371').for(:passport_number) }
    it { expect(user_document).not_to allow_value('Z1352371').for(:passport_number) }
    it { expect(user_document).to allow_value('nvfjg8286p').for(:pan_number) }
    it { expect(user_document).to allow_value('NVFJG8286P').for(:pan_number) }
    it { expect(user_document).not_to allow_value('NVFG88286P').for(:pan_number) }
    it { expect(user_document).not_to allow_value('1VFG88286P').for(:pan_number) }
    it { expect(user_document).not_to allow_value('NVFG882865').for(:pan_number) }
    it { expect(user_document).to allow_value('599490323984').for(:aadhar_number) }
    it { expect(user_document).not_to allow_value('5994 9032 3984').for(:aadhar_number) }
    it { expect(user_document).not_to allow_value('5994asdf3984').for(:aadhar_number) }
  end

  context 'with callbacks' do
    it { expect(user_document).to callback(:upcase_attrs).before(:create) }
  end

  context 'with private instance methods' do
    context 'when creating a document' do
      it 'upcases the passport number if lowercase chars are given' do
        user_document = create :user_document, passport_number: 'p1352371'
        expect(user_document.passport_number).to eq('P1352371')
      end

      it 'upcases the pan number if lowercase chars are given' do
        user_document = create :user_document, pan_number: 'nvfjg8286p'
        expect(user_document.pan_number).to eq('NVFJG8286P')
      end

      it 'if uppercase chars are given to the passport number, it retains the same' do
        user_document = create :user_document, passport_number: 'P1352371'
        expect(user_document.passport_number).to eq('P1352371')
      end

      it 'if uppercase chars are given to the pan number, it retains the same' do
        user_document = create :user_document, pan_number: 'NVFJG8286P'
        expect(user_document.pan_number).to eq('NVFJG8286P')
      end
    end
  end
end
