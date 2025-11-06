require "rails_helper"

RSpec.describe "お問い合わせフォーム", type: :system do
  before do
    Contact.delete_all
  end

  it "messageが入力されていれば送信できる" do
    visit new_contact_path

    fill_in "お問い合わせ内容（必須・1000文字以内）", with: "テストメッセージ"
    fill_in "お名前（任意）", with: "山田太郎"
    fill_in "メールアドレス（任意）", with: "taro@example.com"

    click_button "送信する"

    expect(page).to have_content("お問い合わせを送信しました")

    contact = Contact.last
    expect(contact.message).to eq("テストメッセージ")
    expect(contact.name).to eq("山田太郎")
    expect(contact.email).to eq("taro@example.com")
  end

  it "messageが空だと送信できない" do
    visit new_contact_path

    fill_in "お問い合わせ内容（必須・1000文字以内）", with: ""

    click_button "送信する"

    expect(Contact.count).to eq(0)
  end

  it "nameとemailが空でも送信できる" do
    visit new_contact_path

    fill_in "お問い合わせ内容（必須・1000文字以内）", with: "テストメッセージ"

    click_button "送信する"

    expect(page).to have_content("お問い合わせを送信しました")
    contact = Contact.last
    expect(contact.message).to eq("テストメッセージ")
    expect(contact.name).to be_blank
    expect(contact.email).to be_blank
  end
end
