class CategoriesController < ApplicationController
   skip_before_action :authenticate_user!


  def index
   @categories = Category.all
    respond_to do |format|
     format.html {}
     format.json { render json: @categories }
    end
  end

end
