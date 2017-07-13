class DistributionsController < ApplicationController

  def by_room_id
    begin
      @distribution = Distribution.by_room_id(params[:room_id])
      render json: @distribution
    rescue Exception => e
      distribution = Distribution.new
      distribution.errors.add(:no_room_found, e.message)
      render json: ErrorSerializer.serialize(distribution.errors), status: 500
    end
  end  

end
