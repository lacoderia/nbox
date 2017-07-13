ActiveAdmin.register Pack, :as => "Paquetes" do
	
  actions :all, :except => [:show, :destroy]

  permit_params :classes, :description, :price, :special_price, :expiration, :active

  config.filters = false

  index :title => "Paquetes" do
    column "Descripción", :description
    column "Clases", :classes
    column "Precio", :price
    column "Precio especial", :special_price
    column "Días de expiración", :expiration
    column "Activo", :active
    actions :defaults => true
  end

  form do |f|
    f.inputs "Detalles de paquetes" do
      f.input :description, label: "Descripción"
      f.input :classes, label: "Clases"
      f.input :price, label: "Precio"
      f.input :special_price, label: "Precio especial"
      f.input :expiration, label: "Días de expiración"
      f.input :active, label: "Activo"
    end
    f.actions
  end

end
