class TriggerRefreshSeekingMatview < ActiveRecord::Migration[5.0]
  def change

 execute %{
   CREATE OR REPLACE FUNCTION
     refresh_seeking_matview()
     RETURNS TRIGGER LANGUAGE PLPGSQL
   AS $$
    BEGIN
      REFRESH MATERIALIZED VIEW CONCURRENTLY
    seeking_matview;
      RETURN NULL;
     EXCEPTION
        WHEN feature_not_supported THEN
           RETURN NULL;
      END $$;
 }

 %w(posts
    cities
    categories).each do |table|
   execute %{
      CREATE TRIGGER refresh_seeking_matview
     AFTER
       INSERT OR
       UPDATE OR
       DELETE
      ON #{table}
        FOR EACH STATEMENT
          EXECUTE PROCEDURE
           refresh_seeking_matview()
   }
 end

  end
end
