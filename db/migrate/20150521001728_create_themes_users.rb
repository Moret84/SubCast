class CreateThemesUsers < ActiveRecord::Migration
  def change
    create_table :themes_users, :id => false do |t|
		t.integer :theme_id
		t.integer :user_id
	end
  end
end
