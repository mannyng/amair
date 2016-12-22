class SeekingSearch < ActiveRecord::Base
 self.table_name = 'seeking_search'

  attr_reader :where_clause,  :order

 def readonly?
  true
 end

  def initialize(search_term)
   search_term = search_term.downcase
   @where_clause = ""
    build_for_name_search(search_term)
  end

  def build_for_name_search(search_term)
 end

  def starts_with(search_term)
    search_term + "%"
  end

end
