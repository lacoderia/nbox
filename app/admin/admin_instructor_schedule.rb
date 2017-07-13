ActiveAdmin.register ScheduleForInstructor, :as => "Clases_de_entrenadores" do

  actions :all, :except => [:new, :destroy, :update, :edit]

  filter :datetime, :label => "Horario"
  
  config.sort_order = "datetime_desc"
  
  controller do
    def scoped_collection
      ScheduleForInstructor.for_instructor(current_admin_user.instructor.id)
    end
  end

  index :title => "Clases programadas" do
    
    column "Horario", :datetime
    column "Reservados" do |schedule|
      schedule.appointments.booked.count
    end
    column "Cancelados" do |schedule|
      schedule.appointments.cancelled.count
    end
    column "Confirmados" do |schedule|
      schedule.appointments.finalized.count
    end
    actions :defaults => true
  end

  csv do
    column "Horario" do |schedule|
      schedule.datetime
    end
    column "Instructor" do |schedule|
      "#{schedule.instructor.first_name} #{schedule.instructor.last_name}"
    end
    column "Reservados" do |schedule|
      schedule.appointments.booked.count
    end
    column "Cancelados" do |schedule|
      schedule.appointments.cancelled.count
    end
    column "Confirmados" do |schedule|
      schedule.appointments.finalized.count
    end
  end

  show do |schedule|
    attributes_table do
      row "Horario" do
        schedule.datetime
      end
      row "Reservados" do
        schedule.appointments.booked.map { |appointment| "#{appointment.user.first_name} #{appointment.user.last_name}" if appointment.user  }.join("<br/>").html_safe
      end
      row "Cancelados" do
        schedule.appointments.cancelled.map { |appointment| "#{appointment.user.first_name} #{appointment.user.last_name}" if appointment.user  }.join("<br/>").html_safe
      end
      row "Confirmados" do
        schedule.appointments.finalized.map { |appointment| "#{appointment.user.first_name} #{appointment.user.last_name}" if appointment.user  }.join("<br/>").html_safe
      end
    end
  end

end
