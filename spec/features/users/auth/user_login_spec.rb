# frozen_string_literal: true

describe User do
  it 'can sign in with valid account number' do
    user = create(:user, mobile_verified: true)
    user.user_document = create(:user_document, user: user)
    user_sign_in(user.account_number, user.password)
    expect(page).to have_content I18n.t 'devise.sessions.signed_in'
  end

  it 'can sign in with valid username' do
    user = create(:user, mobile_verified: true)
    user.user_document = create(:user_document, user: user)
    user_sign_in(user.username, user.password)
    expect(page).to have_content I18n.t 'devise.sessions.signed_in'
  end

  it 'cannot sign in if not registered' do
    user_sign_in('testuser', 'please1231@#')
    expect(page).to have_content I18n.t 'devise.failure.not_found_in_database',
      authentication_keys: 'Login'
  end

  it 'cannot sign in with wrong email' do
    user = create(:user)
    user_sign_in('testuser', user.password)
    expect(page).to have_content I18n.t 'devise.failure.not_found_in_database',
      authentication_keys: 'Login'
  end

  it 'cannot sign in with wrong password' do
    user = create(:user)
    user_sign_in(user.username, 'invalidpass')
    expect(page).to have_content I18n.t 'devise.failure.invalid',
      authentication_keys: 'Login'
  end
end
