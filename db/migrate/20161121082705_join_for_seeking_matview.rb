class JoinForSeekingMatview < ActiveRecord::Migration[5.0]
  def change
    execute %{
      CREATE INDEX idx_fts_post ON seeking_matview
      USING gin((setweight(to_tsvector('english', title),'A') || 
       setweight(to_tsvector('english', content), 'B')));
    }
  end
end
