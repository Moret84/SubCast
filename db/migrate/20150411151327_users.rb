class Users < ActiveRecord::Migration
	def self.up
		create_table :users do |t|
			t.column :name, :string, :limit => 20, :null => false
			t.column :password, :string, :null => false
			t.column :email, :string, :null => false
		end
	end
	def self.down
		drop_table :users
	end
end
