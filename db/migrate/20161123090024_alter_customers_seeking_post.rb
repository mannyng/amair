class AlterCustomersSeekingPost < ActiveRecord::Migration[5.0]
  def change
    change_table :customers_seeking_posts do |t|
     t.timestamps
    end
  end
end
