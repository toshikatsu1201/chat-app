require 'rails_helper'

RSpec.describe 'メッセージ投稿機能', type: :system do
  before do
    
    @room_user = FactoryBot.create(:room_user)
  end

  context '投稿に失敗したとき' do
    it '送る値が空の為、メッセージの送信に失敗する' do
      sign_in(@room_user.user)
      click_on(@room_user.room.name)
      expect {
        find('input[name="commit"]').click
      }.not_to change { Message.count }
      expect(page).to have_current_path(room_messages_path(@room_user.room))
    end
  end

  context '投稿に成功したとき' do
    it 'テキストの投稿に成功すると、投稿一覧に遷移して、投稿した内容が表示されている' do
      sign_in(@room_user.user)
      click_on(@room_user.room.name)
      post = 'テスト'
      fill_in 'message_content', with: post
      expect {
        find('input[name="commit"]').click
        sleep 1
      }.to change { Message.count }.by(1)
      expect(page).to have_current_path(room_messages_path(@room_user.room))
      expect(page).to have_content(post)
    end

    it '画像の投稿に成功すると、投稿一覧に遷移して、投稿した画像が表示されている' do
      sign_in(@room_user.user)
      click_on(@room_user.room.name)
      image_path = Rails.root.join('public/images/test_image.png')
      attach_file('message[image]', image_path, make_visible: true)
      expect {
        find('input[name="commit"]').click
        sleep 1
      }.to change { Message.count }.by(1)
      expect(page).to have_current_path(room_messages_path(@room_user.room))
      expect(page).to have_selector('img')
    end

    it 'テキストと画像の投稿に成功する' do
      sign_in(@room_user.user)
      click_on(@room_user.room.name)
      image_path = Rails.root.join('public/images/test_image.png')
      attach_file('message[image]', image_path, make_visible: true)
      post = 'テスト'
      fill_in 'message_content', with: post
      expect {
        find('input[name="commit"]').click
        sleep 1
      }.to change { Message.count }.by(1)
      expect(page).to have_content(post)
      expect(page).to have_selector('img')
    end
  end
end