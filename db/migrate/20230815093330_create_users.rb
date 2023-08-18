class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :handle
      t.string :password
      t.string :image_url
      t.text :description

      t.timestamps
    end
  end
end
