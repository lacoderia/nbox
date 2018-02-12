ActiveAdmin.register CreditModification, :as => "Modificaciones_de_creditos" do

  actions :all, :except => [:destroy, :new]

  filter :user_first_name, :as => :string, :label => "Nombre"
  filter :user_last_name, :as => :string, :label => "Apellido"
  filter :user_email, :as => :string, :label => "Email"
  filter :user_id, :label => "ID del usuario"
  filter :created_at, :label => "Fecha"
  filter :linked, :label => "Ligada"
  
  index :title => "Modificaciones de créditos" do
    column 'ID Usuario' do |credit_modification|
      credit_modification.user.id
    end
    column 'Email Usuario' do |credit_modification|
      credit_modification.user.email
    end
    column 'Nombre Usuario' do |credit_modification|
      "#{credit_modification.user.first_name} #{credit_modification.user.last_name}"
    end

    column "Créditos", :credits
    column "Razón", :reason
    column "Paquete" do |credit_modification|
      "#{credit_modification.pack.description}" if credit_modification.pack
    end
    column "Fecha" do |credit_modification|
      credit_modification.created_at
    end

    actions :defaults => false 
  end

end
