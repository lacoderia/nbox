ActiveAdmin.register Promotion, :as => "Promociones" do

  actions :all, :except => [:show]

  permit_params :coupon, :description, :amount, :active
  
  config.filters = false

  index :title => "Promociones" do
    column "Cupón", :coupon
    column "Descripción", :description
    column "Cantidad", :amount
    column "Activo", :active
    actions :defaults => true
  end

  form do |f|
    f.inputs "Detalles de promociones" do
      f.input :coupon, label: "Cupón"
      f.input :description, label: "Descripción"
      f.input :amount, label: "Cantidad"
      f.input :active, label: "Activo"
    end
    f.actions
  end

end
