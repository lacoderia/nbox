ActiveAdmin.register User, :as => "Resumen_clases_por_usuario" do

  actions :all, :except => [:show, :new, :destroy, :update, :edit]

  filter :first_name, :label => "Nombre"
  filter :last_name, :label => "Apellido"

  scope("#{Date::MONTHNAMES[(Time.zone.now.beginning_of_month - 3.month).month]}"){|scope| scope.where("appointments.start >= ? and appointments.start <= ?", Time.zone.now.beginning_of_month - 3.month, Time.zone.now.end_of_month - 3.month)}
  
  scope("#{Date::MONTHNAMES[(Time.zone.now.beginning_of_month - 2.month).month]}"){|scope| scope.where("appointments.start >= ? and appointments.start <= ?", Time.zone.now.beginning_of_month - 2.month, Time.zone.now.end_of_month - 2.month)}
  
  scope("#{Date::MONTHNAMES[(Time.zone.now.beginning_of_month - 1.month).month]}"){|scope| scope.where("appointments.start >= ? and appointments.start <= ?", Time.zone.now.beginning_of_month - 1.month, Time.zone.now.end_of_month - 1.month)}
  
  scope("#{Date::MONTHNAMES[Time.zone.now.beginning_of_month.month]}"){|scope| scope.where("appointments.start >= ? and appointments.start <= ?", Time.zone.now.beginning_of_month, Time.zone.now.end_of_month)}
  
  scope("All"){|scope| scope}

  controller do
    def scoped_collection
      User.with_appointments_summary
    end
  end

  index :title => "Clientes" do
    column "Nombre", :first_name
    column "Apellido", :last_name
    column "Email", :email
    column "Clases restantes" do |user|
      user.classes_left if not user.linked
    end
    column "Reservadas", :sortable => 'booked' do |user|
      user["booked"]
    end
    column "Canceladas", :sortable => 'cancelled' do |user|
      user["cancelled"]
    end
    column "Finalizadas", :sortable => 'finalized' do |user|
      user["finalized"]
    end
  end

end
