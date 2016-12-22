class Createindexcategorycity < ActiveRecord::Migration[5.0]
  def up

    execute %{
      CREATE INDEX
        seeking_search_ndex
      ON
        seeking_matview USING btree(category, city);
    } 

  end

  def down

    execute %{
      DROP INDEX
        seeking_search_ndex
      ON
        seeking_matview USING btree(category, city);
    }

  end
end
