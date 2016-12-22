class AddPosts < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string :name,           null: false
    end
    create_table :posts do |t|
      t.text :title,    null: false
      t.text :content,       null: false
      t.references :category, null: false
      t.references :city, null: false
      t.text :language,       null: false, default: 'english'
    end
    create_table :tags do |t|
      t.text :name, null: false
    end
    create_table :posts_tags do |t|
      t.references :post, null: false
      t.references :tag, null: false
    end
  end
end
