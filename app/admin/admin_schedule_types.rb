ActiveAdmin.register ScheduleType, :as => "Tipos_de_clase" do
  
  actions :all, :except => :destroy
  
  permit_params :active, :description

  config.filters = false

  index :title => "Tipos" do

    column "Descripción", :description
    column "Activo", :active
    actions :defaults => true
    
  end

  form do |f|
    f.inputs "Detalles de tipos" do
      f.input :description, label: "Descripción"
      f.input :active, label: "Activo"
    end
    f.actions
  end  

end
