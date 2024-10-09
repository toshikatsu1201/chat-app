require 'rails_helper'

RSpec.describe 'ユーザーログイン機能', type: :system do
  it 'ログインしていない状態でトップページにアクセスした場合、サインインページに移動する' do
    visit root_path
    expect(page).to have_current_path(new_user_session_path)
  end

  it 'ログインに成功し、トップページに遷移する' do
    @user = FactoryBot.create(:user)
    visit  new_user_session_path
    expect(page).to have_current_path(new_user_session_path)
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_on('Log in')
    sleep 1
    expect(page).to have_current_path(root_path)
  end

  it 'ログインに失敗し、再びサインインページに戻ってくる' do
    @user = FactoryBot.create(:user)
    visit root_path
    expect(page).to have_current_path(new_user_session_path)
    fill_in 'user_email', with: 'test'
    fill_in 'user_password', with: 'test'
    click_on('Log in')
    expect(page).to have_current_path(new_user_session_path)
  end
end