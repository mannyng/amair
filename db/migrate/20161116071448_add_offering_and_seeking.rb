class AddOfferingAndSeeking < ActiveRecord::Migration[5.0]
  def change
    create_table :customers_offering_posts do |t|
      t.references :post, null: false
      t.references :customer, null: false
    end
    create_table :customers_seeking_posts do |t|
      t.references :post, null: false
      t.references :customer, null: false
    end
  end
end
