class CustomerParameterSanitizer < Devise::ParameterSanitizer

  def initializer(*)
    super
     permit(:sign_up, keys:[:first_name, :last_name, :username, :email, :password, :password_confirmation])
  end
end
