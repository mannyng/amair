class AddCities < ActiveRecord::Migration[5.0]
  def change
    create_table :cities do |t|
      t.string :name,           null: false
      t.integer :postcode
    end  
  end
end
