class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: :json_request?
  before_action :authenticate_user!

 protected

  def json_request?
    request.format.json?
  end

  def devise_parameter_sanitizer
   if resource_class == Customer
    CustomerParameterSanitizer.new(Customer, :customer, params)
   else
    super #to use the default sanitizer
   end
  end

  def after_sign_in_path_for(resource_or_scope)
    case resource_or_scope
     when :customer, Customer
      customers_seeking_posts_path
     when :user, User
       customers_path
     else
       super
     end
  end
end
