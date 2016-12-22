class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :customers_shipping_address
  has_one :customers_billing_address
  has_one :billing_address, through: :customers_billing_address, source: :address
  has_many :customers_offering_post
  has_many :customers_seeking_post

  def primary_shipping_address
    self.customers_shipping_address.find_by(primary: true).address
  end
end
