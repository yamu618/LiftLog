ActiveAdmin.register Contact do
  menu priority: 4, label: "お問い合わせ"
  permit_params :name, :email, :message

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :message do |contact|
      truncate(contact.message, length: 50)
    end
    column :created_at
    actions
  end

  filter :name
  filter :email
  filter :craeted_at

  show do
    attributes_table do
      row :name
      row :email
      row :created_at
      row :message do |contact|
        simple_format(contact.message)
      end
    end
  end
end
