# frozen_string_literal: true

describe User do
  before do
    user_sign_up('Ramesh', 'test@example.com', 'username', '7894561230', 'sunshine')
  end

  it 'lands on mobile verification after signing up' do
    expect(page).to have_current_path(after_signup_path(:verify_mobile))
  end

  it 'can verify the mobile number by inputting the proper OTP' do
    otp = Redis.current.get(described_class.first.id)
    user_mobile_verification(otp)
    expect(page).to have_current_path(after_signup_path(:upload_docs))
  end
end
