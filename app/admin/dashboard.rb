ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: "ダッシュボード"

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "ユーザー数" do
          para User.count
        end

        panel "お問い合わせ件数" do
          para Contact.count
        end
      end

      column do
        panel "最新のユーザー" do
          ul do
            User.order(created_at: :desc).limit(5).each do |user|
              li link_to(user.username, admin_user_path(user))
            end
          end
        end

        panel "最新のお問い合わせ" do
          ul do
            Contact.order(created_at: :desc).limit(5).each do |c|
              li link_to("#{c.name} - #{truncate(c.message, length: 30)}", admin_contact_path(c))
            end
          end
        end
      end
    end
  end
end
