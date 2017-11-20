# frozen_string_literal: true

describe 'Visitor visits landing page', type: :feature do
  it 'successfully and sees the sign up button' do
    visit root_path
    expect(page).to have_content 'Sign Up'
  end

  it 'on clicking the sign up button/link goes to sign up path' do
    visit root_path
    click_on 'Sign Up', match: :first
    expect(page).to have_current_path new_user_registration_path
  end
end
