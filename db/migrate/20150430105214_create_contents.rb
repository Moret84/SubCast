class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.string :title
      t.string :description
      t.string :url
      t.datetime :release_date

      t.timestamps null: false
    end
  end
end
