ActiveAdmin.register User, :as => "Staff_alta" do

  actions :all, :except => [:new, :show, :destroy]

  permit_params :first_name, :last_name, :staff

  filter :last_name, :as => :string
  filter :first_name, :as => :string
  filter :email, :as => :string
  filter :staff, :as => :boolean

  config.sort_order = 'created_at_desc'

  index :title => "Staff" do
    column "Nombre", :first_name
    column "Apellido", :last_name
    column "Email", :email
    column "Staff", :staff

    actions :defaults => true
  end

  form do |f|
    f.inputs "Detalles del staff" do
      f.input :first_name, label: "Nombres", :input_html => { :disabled => true, :style => "background-color: #d3d3d3;" }
      f.input :last_name, label: "Apellido", :input_html => { :disabled => true, :style => "background-color: #d3d3d3;" }
      f.input :email, label: "Email", :input_html => { :disabled => true, :style => "background-color: #d3d3d3;" }
      f.input :staff
    end
    f.actions
  end
  


end
