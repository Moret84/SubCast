class AddFeedToPodcast < ActiveRecord::Migration
  def change
    add_column :podcasts, :feed, :string
  end
end
