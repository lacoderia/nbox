class SchedulesController < ApplicationController
  include BookingSerializer
  include WeeklyScheduleSerializer

  before_action :set_schedule, only: [:bookings]

  # GET /schedules/weekly_scope
  def weekly_scope
    schedules_with_start_date = Schedule.weekly_scope

    render json: WeeklyScheduleSerializer.serialize(schedules_with_start_date)
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
