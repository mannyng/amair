class CitiesController < ApplicationController
  skip_before_action :authenticate_user!


  def index
   #@cities = SeekingMatview.connection.select_all("Select city_id, city from seeking_matview").to_hash
    @cities = City.all
    respond_to do |format|
     format.html {}
     format.json { render json: @cities }
    end
  end

end
