class CreateThemes < ActiveRecord::Migration
  def change
    create_table :themes do |t|
      t.string :name
      t.datetime :last_check

      t.timestamps null: false
    end

	create_table :themes_userss, id: false do |t|
		t.belongs_to :theme, index: true
		t.belongs_to :user, index: true
	end
  end
end
