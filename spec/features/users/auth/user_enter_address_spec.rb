# frozen_string_literal: true

describe User do
  before do
    user_sign_up('Ramesh', 'test@example.com', 'username', '7894561230', 'sunshine')
    otp = Redis.current.get(described_class.first.id)
    user_mobile_verification(otp)
  end

  it 'lands on address enter screen after mobile verification' do
    expect(page).to have_current_path(after_signup_path(:enter_address))
  end

  it 'on successfully entering the address, sees a success toast' do
    user_enters_address('560001')
    expect(page).to have_content I18n.t('after_signup.address_success')
  end

  it 'lands on documents upload screen after successfully entering the inputs' do
    user_enters_address('560001')
    expect(page).to have_current_path(after_signup_path(:upload_docs))
  end

  it 'cannot update address with wrong values' do
    user_enters_address('asdasd')
    expect(page).to have_content I18n.t('after_signup.address_failure')
  end

  it 'stays on verification page on entering wrong OTP' do
    user_enters_address('asdasd')
    expect(page).to have_current_path(after_signup_path(:enter_address))
  end
end
