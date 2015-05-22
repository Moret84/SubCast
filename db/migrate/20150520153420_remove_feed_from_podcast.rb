class RemoveFeedFromPodcast < ActiveRecord::Migration
  def change
	  remove_column :podcasts, :feed
  end
end
