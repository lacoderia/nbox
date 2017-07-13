ActiveAdmin.register Purchase, :as => "Control_de_ingresos" do
  
  actions :all, :except => [:show, :new, :destroy, :update]
  
  filter :created_at, :label => "Fecha"
  filter :user_first_name, :as => :string, :label => "Nombre"
  filter :user_last_name, :as => :string, :label => "Apellido"
  filter :user_email, :as => :string, :label => "Email"

  config.sort_order = "created_at_desc"
  
  scope("#{Date::MONTHNAMES[(Time.zone.now.beginning_of_month - 3.month).month]}"){|scope| scope.where("purchases.created_at >= ? and purchases.created_at <= ?", Time.zone.now.beginning_of_month - 3.month, Time.zone.now.end_of_month - 3.month)}
  
  scope("#{Date::MONTHNAMES[(Time.zone.now.beginning_of_month - 2.month).month]}"){|scope| scope.where("purchases.created_at >= ? and purchases.created_at <= ?", Time.zone.now.beginning_of_month - 2.month, Time.zone.now.end_of_month - 2.month)}
  
  scope("#{Date::MONTHNAMES[(Time.zone.now.beginning_of_month - 1.month).month]}"){|scope| scope.where("purchases.created_at >= ? and purchases.created_at <= ?", Time.zone.now.beginning_of_month - 1.month, Time.zone.now.end_of_month - 1.month)}
  
  scope("#{Date::MONTHNAMES[Time.zone.now.beginning_of_month.month]}"){|scope| scope.where("purchases.created_at >= ? and purchases.created_at <= ?", Time.zone.now.beginning_of_month, Time.zone.now.end_of_month)}

  scope("All"){|scope| scope}
  
  controller do
    def scoped_collection
      Purchase.with_users_and_appointments_and_bom_and_eom
    end
  end

  index :title => "Control de ingresos" do
  
    column "Cliente" do |purchase|
      "#{purchase.user.first_name} #{purchase.user.last_name}"
    end

    column "Compradas" do |purchase|
      purchase.pack.classes
    end

    column "Precio" do |purchase|
      purchase.amount / 100.0
    end

    column "Fecha", :created_at

    column "Usadas" do |purchase|
      appointments_in_month = purchase.user.appointments.finalized.where("start BETWEEN ? and ?", purchase.bom, purchase.eom)
      appointments_in_month.count
    end

    column "Disponibles" do |purchase|
      appointments_in_month = purchase.user.appointments.finalized.where("start BETWEEN ? and ?", purchase.bom, purchase.eom)
      if appointments_in_month.count < purchase.pack.classes
        purchase.pack.classes - appointments_in_month.count
      else
        0
      end
    end

    #column "$ Disponible" do |purchase|
    #  appointments_in_month = purchase.user.appointments.finalized.where("start BETWEEN ? and ?", purchase.bom, purchase.eom)
    #  price_per_class = (purchase.amount / 100.0) / purchase.pack.classes
    #  if appointments_in_month.count <= purchase.pack.classes
    #    appointments_in_month.count * price_per_class
    #  else
    #    purchase.amount / 100.0
    #  end
    #end
 
  end

  csv do

    column "Cliente" do |purchase|
      "#{purchase.user.first_name} #{purchase.user.last_name}"
    end

    column "Compradas" do |purchase|
      purchase.pack.classes
    end

    column "Precio" do |purchase|
      purchase.amount / 100.0
    end

    column "Fecha" do |purchase|
      purchase.created_at
    end

    column "Usadas" do |purchase|
      appointments_in_month = purchase.user.appointments.finalized.where("start BETWEEN ? and ?", purchase.bom, purchase.eom)
      appointments_in_month.count
    end
    
    column "Disponibles" do |purchase|
      appointments_in_month = purchase.user.appointments.finalized.where("start BETWEEN ? and ?", purchase.bom, purchase.eom)
      if appointments_in_month.count < purchase.pack.classes
        purchase.pack.classes - appointments_in_month.count
      else
        0
      end
    end

    #column "$ Disponible" do |purchase|
    #  appointments_in_month = purchase.user.appointments..finalized.where("start BETWEEN ? and ?", purchase.bom, purchase.eom)
    #  price_per_class = (purchase.amount / 100.0) / purchase.pack.classes
    #  if appointments_in_month.count <= purchase.pack.classes
    #    appointments_in_month.count * price_per_class
    #  else
    #    purchase.amount / 100.0
    #  end
    #end
    
  end
  
end
