class AlterSeekingMatview < ActiveRecord::Migration[5.0]

  def change

     execute %{
       DROP MATERIALIZED VIEW seeking_matview
     }

     execute <<-SQL
      CREATE MATERIALIZED VIEW seeking_matview AS
        SELECT
         p.id           AS post_id,
         p.created_at   AS created_at,
         p.updated_at   AS updated_at,
         p.content      AS content,
         p.title        AS title,
         c.id           AS city_id,
         c.name         AS city,
         c.postcode     AS city_postcode,
         ca.id          AS category_id,
         ca.name        AS category,
         sp.id          AS seeking_post_id,
         sp.customer_id AS seeking_customer_id,
         sp.post_id        AS seeking_post
       FROM posts p
       INNER JOIN customers_seeking_posts sp ON p.id = sp.post_id
       INNER JOIN cities c ON c.id = p.city_id
       INNER JOIN categories ca ON ca.id = p.category_id
       GROUP BY p.id, c.id, ca.id, sp.id
    SQL

   execute %{
    CREATE UNIQUE INDEX
        seeking_matview_post_id
      ON
        seeking_matview(post_id)
    }
  end
end

