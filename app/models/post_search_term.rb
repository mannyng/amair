class PostSearchTerm

 attr_reader :where_clause, :where_args, :order

   def initialize(search_term)
    search_term = search_term.downcase
    @where_clause = ""
    @where_args = {}
    build_for_post_search(search_term)
   end

  def build_for_post_search(search_term)
      @where_clause <<
    case_insensitive_search(":seeking @> ?") 
      @where_args{seeking:{category:"params[:category]",location:"params[:location]"[:description] = starts_with(search_term)}}






