class SeekingMatview < ActiveRecord::Base
  self.table_name = 'seeking_matview'
  self.primary_key = 'post_id'

   def create(params)
    Post.create(params.permit(:title, :content, :category_id, :city_id))
    CustomersSeekingPost.create(params.permit(:post_id, :customer_id))
  end 

#  def readonly?
#    true
#  end

#  def self.refresh
#    ActiveRecord::Base.connection.execute('REFRESH MATERIALIZED VIEW CONCURRENTLY seeking_matview')
#  end

end
