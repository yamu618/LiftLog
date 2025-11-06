class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      flash[:notice] = "お問い合わせを送信しました"
      redirect_to new_contact_path
    else
      flash.now[:alert] = "送信に失敗しました。もう一度お試しください"
      render :new, status: :unprocessable_entity
    end
  end

  private
  
  def contact_params
    params.require(:contact).permit(:name, :email, :message)
  end
end
