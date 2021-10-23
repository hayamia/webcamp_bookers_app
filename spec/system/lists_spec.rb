require 'rails_helper'

describe '投稿のテスト' do
  let!(:list) { create(:list,title:'hoge',body:'body') }
  describe 'トップ画面(root_path)のテスト' do
    before do 
      visit root_path
    end
    context '表示の確認' do
      it 'トップ画面(root_path)に一覧ページへのリンクが表示されているか' do
        expect(page).to have_link "", href: lists_path
      end
      it 'root_pathが"/"であるか' do
        expect(current_path).to eq('/')
      end
    end
  end
  describe "一覧画面のテスト" do
    before do
      visit lists_path
    end
    context '一覧の表示とリンクの確認' do
      it "listの一覧表示(tableタグ)と投稿フォームが同一画面に表示されているか" do
        expect(page).to have_selector 'table'
        expect(page).to have_field 'list[title]'
        expect(page).to have_field 'list[body]'
      end
      it "listのタイトルと感想を表示し、詳細・編集・削除のリンクが表示されているか" do
          (1..5).each do |i|
            List.create(title:'hoge'+i.to_s,body:'body'+i.to_s)
          end
          visit lists_path
          List.all.each_with_index do |list,i|
            j = i * 3
            expect(page).to have_content list.title
            expect(page).to have_content list.body
            # Showリンク
            show_link = find_all('a')[j]
            expect(show_link.native.inner_text).to match(/show/i)
            expect(show_link[:href]).to eq list_path(list)
            # Editリンク
            show_link = find_all('a')[j+1]
            expect(show_link.native.inner_text).to match(/edit/i)
            expect(show_link[:href]).to eq edit_list_path(list)
            # Destroyリンク
            show_link = find_all('a')[j+2]
            expect(show_link.native.inner_text).to match(/destroy/i)
            expect(show_link[:href]).to eq list_path(list)
          end
      end
      it 'Create Listボタンが表示される' do
        expect(page).to have_button 'Create List'
      end
    end
    context '投稿処理に関するテスト' do
      it '投稿に成功しサクセスメッセージが表示されるか' do
        fill_in 'list[title]', with: Faker::Lorem.characters(number:5)
        fill_in 'list[body]', with: Faker::Lorem.characters(number:20)
        click_button 'Create List'
        expect(page).to have_content 'successfully'
      end
      it '投稿に失敗する' do
        click_button 'Create List'
        expect(page).to have_content 'error'
        expect(current_path).to eq('/lists')
      end
      it '投稿後のリダイレクト先は正しいか' do
        fill_in 'list[title]', with: Faker::Lorem.characters(number:5)
        fill_in 'list[body]', with: Faker::Lorem.characters(number:20)
        click_button 'Create List'
        expect(page).to have_current_path list_path(List.last)
      end
    end
    context 'list削除のテスト' do
      it 'listの削除' do
        expect{ list.destroy }.to change{ List.count }.by(-1)
        # ※本来はダイアログのテストまで行うがココではデータが削除されることだけをテスト
      end
    end
  end
  describe '詳細画面のテスト' do
    before do
      visit list_path(list)
    end
    context '表示の確認' do
      it '本のタイトルと感想が画面に表示されていること' do
        expect(page).to have_content list.title
        expect(page).to have_content list.body
      end
      it 'Editリンクが表示される' do
        edit_link = find_all('a')[0]
        expect(edit_link.native.inner_text).to match(/edit/i)
			end
      it 'Backリンクが表示される' do
        back_link = find_all('a')[1]
        expect(back_link.native.inner_text).to match(/back/i)
			end  
    end
    context 'リンクの遷移先の確認' do
      it 'Editの遷移先は編集画面か' do
        edit_link = find_all('a')[0]
        edit_link.click
        expect(current_path).to eq('/lists/' + list.id.to_s + '/edit')
      end
      it 'Backの遷移先は一覧画面か' do
        back_link = find_all('a')[1]
        back_link.click
        expect(page).to have_current_path lists_path
      end
    end
  end
  describe '編集画面のテスト' do
    before do
      visit edit_list_path(list)
    end
    context '表示の確認' do
      it '編集前のタイトルと感想がフォームに表示(セット)されている' do
        expect(page).to have_field 'list[title]', with: list.title
        expect(page).to have_field 'list[body]', with: list.body
      end
      it 'Update Listボタンが表示される' do
        expect(page).to have_button 'Update List'
      end
      it 'Showリンクが表示される' do
        show_link = find_all('a')[0]
        expect(show_link.native.inner_text).to match(/show/i)
			end  
      it 'Backリンクが表示される' do
        back_link = find_all('a')[1]
        expect(back_link.native.inner_text).to match(/back/i)
			end  
    end
    context 'リンクの遷移先の確認' do
      it 'Showの遷移先は詳細画面か' do
        show_link = find_all('a')[0]
        show_link.click
        expect(current_path).to eq('/lists/' + list.id.to_s)
      end
      it 'Backの遷移先は一覧画面か' do
        back_link = find_all('a')[1]
        back_link.click
        expect(page).to have_current_path lists_path
      end
    end
    context '更新処理に関するテスト' do
      it '更新に成功しサクセスメッセージが表示されるか' do
        fill_in 'list[title]', with: Faker::Lorem.characters(number:5)
        fill_in 'list[body]', with: Faker::Lorem.characters(number:20)
        click_button 'Update List'
        expect(page).to have_content 'successfully'
      end
      it '更新に失敗しエラーメッセージが表示されるか' do
        fill_in 'list[title]', with: ""
        fill_in 'list[body]', with: ""
        click_button 'Update List'
        expect(page).to have_content 'error'
      end
      it '更新後のリダイレクト先は正しいか' do
        fill_in 'list[title]', with: Faker::Lorem.characters(number:5)
        fill_in 'list[body]', with: Faker::Lorem.characters(number:20)
        click_button 'Update List'
        expect(page).to have_current_path list_path(list)
      end
    end
  end
end