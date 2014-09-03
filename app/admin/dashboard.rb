ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do

    columns do
      column do
        panel "Twitter" do
          para "Just added! \"#{Movie.latest.first.title}\" - See more new movies at http://www.hbizzle.com/latest! #hbizzle"
          a 'Tweet!', href: tweet_update_path
        end
      end
    end
  end # content
end
