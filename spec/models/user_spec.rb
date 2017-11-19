# frozen_string_literal: true

describe User, type: :model do
  let(:user) { create :user }

  it 'has a valid factory' do
    expect(create(:user)).to be_valid
  end
end
