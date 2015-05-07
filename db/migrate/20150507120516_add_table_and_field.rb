class AddTableAndField < ActiveRecord::Migration
  def change
	  create_table :users_contents, id: false do |t|
		  t.belongs_to :user, index: true
		  t.belongs_to :content, index: true
	  end

	  create_table :users_podcasts, id: false do |t|
		  t.belongs_to :user, index: true
		  t.belongs_to :podcast, index: true
	  end

	add_reference :contents, :podcast, index: true
  end
end
