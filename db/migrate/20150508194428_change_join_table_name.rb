class ChangeJoinTableName < ActiveRecord::Migration
  def change
	rename_table :users_contents, :contents_users
	rename_table :users_podcasts, :podcasts_users
  end
end
