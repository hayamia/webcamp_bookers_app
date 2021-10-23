# frozen_string_literal: true

require 'rails_helper'

RSpec.describe List, "モデルに関するテスト", type: :model do
  describe '実際に保存してみる' do
    it "有効な投稿内容の場合は保存されるか" do
      expect(FactoryBot.build(:list)).to be_valid
    end
  end
  context "空白のバリデーションチェック" do
    it "titleが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      list = List.new(title: '', body:'hoge')
      expect(list).to be_invalid
      expect(list.errors[:title]).to include("can't be blank")
    end
    it "bodyが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      list = List.new(title: 'hoge', body:'')
      expect(list).to be_invalid
      expect(list.errors[:body]).to include("can't be blank")
    end
  end
  feature "titleを空白で投稿した場合に画面にエラーメッセージが表示されているか" do
    before do
      visit lists_path
      fill_in 'list[title]', with: ''
    end
    scenario "エラーメッセージは正しく表示されるか" do
      find("input[name='commit']").click
      expect(page).to have_content "can't be blank"
    end
  end
  feature "bodyを空白で投稿した場合に画面にエラーメッセージが表示されているか" do
    before do
      visit lists_path
      fill_in 'list[body]', with: ''
    end
    scenario "エラーメッセージは正しく表示されるか" do
      find("input[name='commit']").click
      expect(page).to have_content "can't be blank"
    end
  end
  

end
