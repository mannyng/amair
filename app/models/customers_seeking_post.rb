class CustomersSeekingPost < ActiveRecord::Base
  belongs_to :customer
  belongs_to :post
end
