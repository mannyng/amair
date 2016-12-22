class CustomersSeekingPostsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :authenticate_customer!, except:[:index, :show] 


   PAGE_SIZE = 10
  def index
   @page = (params[:page] || 0).to_i
   if params[:keywords].present?
     @keywords = params[:keywords]
     #seeking_search = SeekingSearch.new(@keywords)
     @customers_seeking_posts = SeekingMatview
     .where(
      "setweight(to_tsvector('english',title), 'A')|| setweight(to_tsvector('english',content), 'B') @@ plainto_tsquery(:q)", q: @keywords)
     .order(" ts_rank(to_tsvector('english',title), plainto_tsquery (':q')) DESC  ")
     .offset(PAGE_SIZE * @page).limit(PAGE_SIZE)
   else
    @customers_seeking_posts = []
  end
  respond_to do |format|
   format.html {}
   format.json { render json: @customers_seeking_posts }
  end
 end

   def show
    seeking_detail = SeekingMatview.find(params[:id]) 
    respond_to do |format|
     format.json  { render json: seeking_detail }
    end
  end

   def update
    seeking_detail = SeekingMatview.find(params[:id])
    seeking_detail.update(params)
    head :ok
   end

  def new
   @c_s_post = CustomersSeekingPost.new
  end

  def create
    @seeking_post = Post.create(params.permit(:title, :content, :category_id, :city_id))
    if @seeking_post.new_record?
   @c_s_post = CustomersSeekingPost.new(params.permit(post_id: @seeking_post.id, customer_id: 765))
    @c_s_post.save
   else 
    render "new"
   end
  end

end
