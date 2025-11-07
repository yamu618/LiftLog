ActiveAdmin.register User do
  menu priority: 3, label: "ユーザー"
  permit_params :username, :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :username
    column :email
    column :created_at
    actions
  end

  filter :email
  filter :username
  filter :created_at

  form do |f|
    f.inputs do
      f.input :username
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
