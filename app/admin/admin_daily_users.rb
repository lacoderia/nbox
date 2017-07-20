ActiveAdmin.register Appointment, :as => "Clientes_del_dia" do 
  
  actions :all, :except => [:show, :new, :destroy, :update, :edit]

  filter :start, :as => :date_time_range, :label => "Horario", datepicker_options: {min_date: Time.zone.now.beginning_of_day, max_date: Time.zone.now.end_of_day + 1.day}
  
  filter :schedule_instructor_first_name, :as => :string, :label => "Nombre del instructor"
  
  filter :user_last_name, :as => :string, :label => "Apellido de cliente"

  config.sort_order = 'start_asc, station_number_asc'

  before_filter only: :index do
    # when arriving through top navigation
    if params.keys == ["controller", "action"]
      extra_params = {"q" => {"start_gteq" => Time.zone.now.beginning_of_day, "start_lteq" => Time.zone.now.end_of_day}}

      # make sure data is filtered and filters show correctly
      params.merge! extra_params

      # make sure downloads and scopes use the default filter
      request.query_parameters.merge! extra_params
    end
  end

  controller do
    def scoped_collection
      Appointment.not_cancelled_with_users_and_schedules
    end
  end

  index :title => "Clientes del dia" do
    column "Horario", :start
    column "Estación", :station_number
    column 'Nombre' do |appointment|
      "#{appointment.user.first_name} #{appointment.user.last_name}"
    end
    column 'Instructor' do |appointment|
      "#{appointment.schedule.instructor.first_name} #{appointment.schedule.instructor.last_name}" if appointment.schedule
    end
  end

  csv do
    column "Horario" do |appointment|
      appointment.start
    end
    column "Estación" do |appointment|
      appointment.station_number
    end
    column 'Nombre' do |appointment|
      "#{appointment.user.first_name} #{appointment.user.last_name}"
    end
    column 'Instructor' do |appointment|
      "#{appointment.schedule.instructor.first_name} #{appointment.schedule.instructor.last_name}"
    end
  end

end
