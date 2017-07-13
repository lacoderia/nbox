class AppointmentsController < ApiController 
  include ErrorSerializer
  
  before_action :authenticate_user!, only: [:book, :cancel, :weekly_scope_for_user, :historic_for_user]
  
  before_action :set_appointment, only: [:cancel, :edit_bicycle_number]

  # POST /appointments/book
  def book
    begin
      appointment = Appointment.book(params, current_user)
      SendEmailJob.perform_later("booking", current_user, appointment)
      render json: appointment
    rescue Exception => e
      appointment = Appointment.new
      appointment.errors.add(:error_creating_appointment, e.message)
      render json: ErrorSerializer.serialize(appointment.errors), status: 500
    end
  end

  def cancel
    begin
      @appointment.cancel_with_time_check
      render json: @appointment
    rescue Exception => e
      appointment = Appointment.new
      appointment.errors.add(:error_creating_appointment, e.message)
      render json: ErrorSerializer.serialize(appointment.errors), status: 500
    end
  end

  def edit_bicycle_number
    begin
      @appointment.edit_bicycle_number(params[:bicycle_number].to_i)
      SendEmailJob.perform_later("booking", current_user, @appointment)
      render json: @appointment      
    rescue Exception => e
      appointment = Appointment.new
      appointment.errors.add(:error_editing_appointment, e.message)
      render json: ErrorSerializer.serialize(appointment.errors), status: 500
    end
  end

  def weekly_scope_for_user
    @appointments = Appointment.weekly_scope_for_user(current_user)
    render json: @appointments
  end

  def historic_for_user
    @appointments = Appointment.historic_for_user(current_user)
    render json: @appointments
  end

  private

    def set_appointment
      begin
        @appointment = Appointment.find(params[:id])
      rescue Exception => e
        @appointment = Appointment.new
        @appointment.errors.add(:not_found, "Clase no encontrada.")
        render json: ErrorSerializer.serialize(@appointment.errors), status: 500
      end
    end
end

