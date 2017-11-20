# frozen_string_literal: true

module SessionHelpers
  def user_sign_up(name, email, username, mobile_number, password)
    visit new_user_registration_path
    fill_in 'user[first_name]', with: name
    fill_in 'user[last_name]', with: name
    fill_in 'user[email]', with: email
    fill_in 'user[username]', with: username
    fill_in 'user[mobile_number]', with: mobile_number
    fill_in 'user[password]', with: password, match: :prefer_exact
    # click_button 'Sign up'
    find(:xpath, "//input[contains(@name, 'commit')]").click
  end

  def user_sign_in(login, password)
    visit new_user_session_path
    fill_in 'user[login]', with: login
    fill_in 'user[password]', with: password
    # click_button 'Sign in'
    find(:xpath, "//input[contains(@name, 'commit')]").click
  end

  def user_mobile_verification(otp)
    fill_in 'user[otp]', with: otp
    find(:xpath, "//input[contains(@name, 'commit')]").click
  end

  def user_enters_address(pincode)
    fill_in 'address[address_line_1]', with: 'Some long address'
    fill_in 'address[city]', with: 'Bangalore'
    select('Karnataka', from: 'address[state]').select_option
    fill_in 'address[pincode]', with: pincode
    find(:xpath, "//input[contains(@name, 'commit')]").click
  end
end
