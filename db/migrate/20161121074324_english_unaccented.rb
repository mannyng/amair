class EnglishUnaccented < ActiveRecord::Migration[5.0]
  def change
   execute %{
    CREATE TEXT SEARCH CONFIGURATION public.english ( COPY = pg_catalog.english );
    ALTER TEXT SEARCH CONFIGURATION public.english ALTER MAPPING
    FOR asciiword, asciihword, hword_asciipart, hword, hword_part, word WITH english_stem;
  }
  end
end
