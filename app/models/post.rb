class Post < ActiveRecord::Base
 belongs_to :city
 belongs_to :category
 has_many :customers_seeking_posts
  accepts_nested_attributes_for :customers_seeking_posts, reject_if: lambda {|attributes| attributes['post_id','customer_id'].blank}, allow_destroy: true
end
