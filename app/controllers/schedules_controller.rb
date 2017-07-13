class SchedulesController < ApplicationController
  include ErrorSerializer
  include BookingSerializer

  before_action :set_schedule, only: [:bookings]

  # GET /schedules/weekly_scope
  def weekly_scope
    schedules = Schedule.weekly_scope

    render json: schedules
  end

  # GET /schedules/(:id)/bookings
  def bookings
    bookings = @schedule.bookings
    render json: BookingSerializer.serialize(bookings)
  end

  private

    def set_schedule
      @schedule = Schedule.find(params[:id])
    end

end
