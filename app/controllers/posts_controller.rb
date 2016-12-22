class PostsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :authenticate_customer!, except:[:index, :show]
  

   PAGE_SIZE = 10
  def index
   @page = (params[:page] || 0).to_i
   if params[:keywords].present?
     @keywords = params[:keywords]
     seeking_search = SeekingSearch.new(@keywords)
     @customers_seeking_posts = CustomersSeekingPosts.where(
       seeking_search.where).
       order(seeking.search.order).
       offset(PAGE_SIZE * @page).limit(PAGE_SIZE)
   else
    @customers_seeking_posts = []
  end
  respond_to do |format|
   format.html {}
   format.json { render json: @customers_seeking_posts }
  end
 end
 

  def new
   @seeking_post = Post.new
  end

   def create
     @seeking_post = Post.create(post_params)
     @s_post = CustomersSeekingPost.new(post_id: @seeking_post.id, customer_id: 779)
     if @seeking_post.valid? and @s_post.valid?
      (@seeking_post && @s_post).save!
    
   else 
    render "new"
   end
  end

private

  def post_params
    params.require(:post).permit(:title, :content, :category_id, :city_id, customers_seeking_posts_attributes: [:id, :post_id, :customer_id])
   end

end
