class AddIndexonContent < ActiveRecord::Migration[5.0]
  def up
   execute %{
    CREATE INDEX seeking_content ON seeking_matview
     USING gin(to_tsvector('english', content));
    }
   execute %{    
    CREATE INDEX seeking_title ON seeking_matview
     USING gin(to_tsvector('english', title));
    }
  end

  def down
   execute %{
    DROP INDEX seeking_title IF EXISTS;
    }
   execute %{
    DROP INDEX seeking_content IF EXISTS;
    }
  end
end
