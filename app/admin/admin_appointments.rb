ActiveAdmin.register User, :as => "Resumen_clases_por_usuario" do

  actions :all, :except => [:show, :new, :destroy, :update, :edit]

  filter :first_name, :label => "Nombre"
  filter :last_name, :label => "Apellido"

  scope("Hace 3 meses"){|scope| scope.where("appointments.start >= ? and appointments.start <= ?", Time.zone.now.beginning_of_month - 3.month, Time.zone.now.end_of_month - 3.month)}
  
  scope("Hace 2 meses"){|scope| scope.where("appointments.start >= ? and appointments.start <= ?", Time.zone.now.beginning_of_month - 2.month, Time.zone.now.end_of_month - 2.month)}
  
  scope("Hace 1 mes"){|scope| scope.where("appointments.start >= ? and appointments.start <= ?", Time.zone.now.beginning_of_month - 1.month, Time.zone.now.end_of_month - 1.month)}
  
  scope("Mes actual"){|scope| scope.where("appointments.start >= ? and appointments.start <= ?", Time.zone.now.beginning_of_month, Time.zone.now.end_of_month)}

  controller do
    def scoped_collection
      User.with_appointments_summary
    end
  end

  index :title => "Clientes" do
    column "Nombre", :first_name
    column "Apellido", :last_name
    column "Email", :email
    column "Clases restantes", :classes_left
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
