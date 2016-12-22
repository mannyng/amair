class AddPostNewIndex < ActiveRecord::Migration[5.0]
  def up
   execute %{
     CREATE INDEX
      postnew_index ON
    seeking_matview(city_id, city)
  }
  end
  def down
   execute %{
    DROP INDEX postnew_index
   }
  end
end
