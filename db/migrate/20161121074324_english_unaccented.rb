class EnglishUnaccented < ActiveRecord::Migration[5.0]
  def change
   execute %{
    CREATE TEXT SEARCH CONFIGURATION english ( COPY = english );
    ALTER TEXT SEARCH CONFIGURATION english ALTER MAPPING
    FOR hword, hword_part, word WITH unaccent, english_stem;
  }
  end
end
