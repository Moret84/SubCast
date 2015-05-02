class CreatePodcasts < ActiveRecord::Migration
  def change
    create_table :podcasts do |t|
      t.string :title
      t.string :rss_link
      t.datetime :last_check

      t.timestamps null: false
    end
  end
end
