class EnglishUnaccented < ActiveRecord::Migration[5.0]
  def change
   execute %{
    CREATE TEXT SEARCH CONFIGURATION public.english ( COPY = pg_catalog.english );
    ALTER TEXT SEARCH CONFIGURATION public.english ALTER MAPPING
    FOR hword, hword_part, word WITH unaccent, english_stem;
  }
  end
end
