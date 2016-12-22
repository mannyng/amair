class CustomersOfferingPost < ActiveRecord::Base
  belongs_to :customer
  belongs_to :post
end
