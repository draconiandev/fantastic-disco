# frozen_string_literal: true

describe User do
  # user_sign_up(name, email, username, mobile_number, password)
  it 'signs up successfully with valid credentials' do
    user_sign_up('Ramesh', 'test@example.com', 'username', '7894561230', 'sunshine')
    expect(page).to have_content 'Log Out'
  end

  it 'cannot sign up with invalid email address' do
    user_sign_up('Ramesh', 'bogus', 'username', '7894561230', 'sunshine')
    expect(page).to have_content 'is invalid'
  end

  it 'cannot sign up with invalid name format' do
    user_sign_up('Mr. 123', 'bogus', 'username', '7894561230', 'sunshine')
    expect(page).to have_content 'is invalid'
  end

  it 'cannot sign up without password' do
    user_sign_up('Ramesh', 'test@example.com', 'username', '7894561230', '')
    expect(page).to have_content "can't be blank"
  end

  it 'cannot sign up without names' do
    user_sign_up('', 'test@example.com', 'username', '7894561230', 'sunshine')
    expect(page).to have_content "can't be blank"
  end

  it 'cannot sign up with a short password' do
    user_sign_up('Ramesh', 'test@example.com', 'username', '7894561230', 'suns')
    expect(page).to have_content 'is too short'
  end

  it 'cannot sign up with a short username' do
    user_sign_up('Ramesh', 'test@example.com', 'u1', '7894561230', 'suns')
    expect(page).to have_content 'is too short'
  end
end
