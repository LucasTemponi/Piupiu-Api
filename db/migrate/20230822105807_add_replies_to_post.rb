class AddRepliesToPost < ActiveRecord::Migration[7.0]
  def change
    add_reference :posts, :main_post, foreign_key: { to_table: :posts }
  end
end
