class SeekingMatviewController < ApplicationController

   PAGE_SIZE = 10
  def index
   @page = (params[:page] || 0).to_i
   if params[:keywords].present?
     @keywords = params[:keywords]
     @category = params[:category]
     @city = params[:location]
     #seeking = SeekingMatview.new(@keywords) 
    @customers_seeking_posts = SeekingMatview
     .where(
     "to_tsvector('english', category) @@ plainto_tsquery(:ca) AND
     to_tsvector('english', city) @@ plainto_tsquery(:ci) AND
     to_tsvector('english', title) @@ plainto_tsquery(:q) OR
     to_tsvector('english', content) @@ plainto_tsquery(:q)", q: @keywords, ca: @category, ci: @city).order("content asc")
     .offset(PAGE_SIZE * @page).limit(PAGE_SIZE)
     else
      @customers_seeking_posts = []
     end
     respond_to do |format|
     format.html {}
     format.json { render json: @customers_seeking_posts }
     end
   end
end

