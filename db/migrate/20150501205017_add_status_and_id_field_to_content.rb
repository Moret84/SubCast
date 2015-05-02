class AddStatusAndIdFieldToContent < ActiveRecord::Migration
  def change
    add_column :contents, :status, :integer
    add_column :contents, :on_server_id, :string
  end
end
