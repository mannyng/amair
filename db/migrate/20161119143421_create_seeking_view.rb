class CreateSeekingView < ActiveRecord::Migration[5.0]
  def change
  
     execute <<-SQL
      CREATE MATERIALIZED VIEW seeking_matview AS
        SELECT p.content AS content,
        p.title AS title,
        c.name AS city,
        ca.name AS category
      FROM posts p
      INNER JOIN cities c ON c.id = p.city_id
      INNER JOIN categories ca ON ca.id = p.category_id
      GROUP BY title, content, city, category
    SQL

 end
end
