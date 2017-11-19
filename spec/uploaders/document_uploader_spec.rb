# frozen_string_literal: true

require 'carrierwave/test/matchers'

describe DocumentUploader do
  include CarrierWave::Test::Matchers

  let(:user_document) { build :user_document }
  let(:uploader) { described_class.new(user_document, :pan) }

  before do
    described_class.enable_processing = true
    File.open(file_fixture('sample.jpg')) { |f| uploader.store!(f) }
  end

  after do
    described_class.enable_processing = false
    uploader.remove!
  end

  it 'makes the image only readable to everyone and not executable' do
    expect(uploader).to have_permissions(0o644)
  end

  it 'has the correct format' do
    expect(uploader).to be_format('jpeg')
  end
end
