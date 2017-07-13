ActiveAdmin.register Instructor, :as => "Instructores" do

  actions :all, :except => [:show, :destroy]

  permit_params :first_name, :last_name, :picture, :picture_2, :quote, :bio, :active, admin_user_attributes: [:id, :email, :password, :password_confirmation, :role_ids]

  config.filters = false

  controller do
    def update
      if not current_admin_user.role? :niumedia
        if params[:instructor][:admin_user_attributes][:password].blank?
          params[:instructor][:admin_user_attributes].delete("password")
          params[:instructor][:admin_user_attributes].delete("password_confirmation")
        end
      end
      super
    end
  end
  
  index :title => "Instructores" do
    column "Nombre", :first_name	
    column "Apellido", :last_name
    column "Email" do |instructor|
      instructor.admin_user.email
    end
    column "Foto", :picture
    column "Foto_2", :picture_2
    column "Cita", :quote
    column "Bio", :bio
    column "Activo", :active
    actions :defaults => true
  end

  form do |f|
    if not current_admin_user.role? :niumedia
      f.inputs "Detalles de cuenta" do
        1.times do
          if f.object.new_record?
            f.object.build_admin_user
          end
        end
        f.fields_for :admin_user do |t|
          instructor_role = Role.find_by_name(:instructor)
          t.input :email
          t.input :password
          t.input :password_confirmation
          t.input :role_ids, as: :hidden, input_html: { value: instructor_role.id }
        end
      end
    end
    f.inputs "Detalles de instructor" do
      f.input :first_name, label: "Nombre"
      f.input :last_name, label: "Apellido"
      f.input :picture, label: "Foto"
      f.input :picture_2, label: "Foto_2"
      f.input :quote, label: "Cita"
      f.input :bio, label: "Bio"
      f.input :active, label: "Activo"
      f.actions
    end
  end

end
