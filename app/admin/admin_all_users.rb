ActiveAdmin.register User, :as => "Todos_los_clientes" do

  actions :all, :except => [:new, :show, :destroy]

  permit_params :classes_left, :last_class_purchased, :expiration_date, credit_modifications_attributes: [:user_id, :reason, :credits, :pack_id], purchases_attributes: [:user_id, :pack_id, :object, :livemode, :status, :description, :amount, :currency, :payment_method, :details]
  
  filter :first_name, :as => :string, :label => "Nombre"
  filter :last_name, :as => :string, :label => "Apellido"
  filter :email, :as => :string
  filter :linked, :label => "Ligada"

  config.sort_order = 'created_at_desc'

  action_item only: :edit do
    if resource.is_a?(User) and resource.purchases.empty?
      link_to "Delete", admin_todos_los_cliente_path(resource.id), method: :delete, data: {:confirm => "Eliminarás al usuario. ¿Estás seguro?"}
    end
  end

  controller do
    def destroy
      super
    end

    def update
      if (not params[:user][:credit_modifications_attributes].to_unsafe_h.first[1][:credits].blank?) and
        (params[:user][:credit_modifications_attributes].to_unsafe_h.first[1][:credits] != 0)
        params[:user][:classes_left] = params[:user][:classes_left].to_i + (params[:user][:credit_modifications_attributes].to_unsafe_h.first[1][:credits].to_i)
        user = User.find(params[:id])
        
        if not params[:user][:credit_modifications_attributes].to_unsafe_h.first[1][:pack_id].blank?
          
          pack = Pack.find(params[:user][:credit_modifications_attributes].to_unsafe_h.first[1][:pack_id])
          if user.purchases.empty? and not pack.special_price.nil?
            amount = pack.special_price.to_i*100
          else
            amount = pack.price.to_i*100
          end

          purchase = {"1" => {"user_id" => user.id,
                              "pack_id" => pack.id, 
                              "object" => "charge", 
                              "livemode" => true, 
                              "status" => "paid",
                              "description" => pack.description,
                              "amount" => amount,
                              "currency" => "MXN",
                              "payment_method" => "cash",
                              "details" => "pago en efecitvo"
          } }

          params[:user][:purchases_attributes] = purchase

          if user.expiration_date
            if user.expiration_date <= Time.zone.now
              expiration_date = Time.zone.now + pack.expiration.days
            else
              expiration_date = user.expiration_date + pack.expiration.days
            end
          else
            expiration_date = Time.zone.now + pack.expiration.days
          end
          
        else
          
          credits = params[:user][:credit_modifications_attributes].to_unsafe_h.first[1][:credits].to_i
          less_or_equal_to_zero = ->(x) { x <= 0 }

          case credits
            when less_or_equal_to_zero
              expiration = 0
            when 1..4
              expiration = 15
            when 5..9
              expiration = 30
            when 10..24
              expiration = 90
            when 25..49
              expiration = 180
            else
              expiration = 360
            end
                
          if user.expiration_date and expiration > 0

            if user.expiration_date <= Time.zone.now
              expiration_date = Time.zone.now + expiration.days
            else
              expiration_date = user.expiration_date + expiration.days
            end

          elsif not user.expiration_date and expiration > 0
            expiration_date = Time.zone.now + expiration.days
          end

        end
        
        params[:user][:last_class_purchased] = Time.zone.now if expiration_date
        params[:user][:expiration_date] = expiration_date if expiration_date 
      end
      super
    end
  end

  index :title => "Clientes" do
    column "Nombre", :first_name
    column "Apellido", :last_name
    column "Email", :email
    column "Clases restantes" do |user|
      user.classes_left if not user.linked
    end
    column "Ligada", :linked

    actions defaults: false do |user|
      links = ""
      links += "#{link_to "View Credits", "#{admin_modificaciones_de_creditos_path}?q%5Buser_id_equals%5D=#{user.id}&commit=Filter&order=id_desc"} " if not user.linked
      links += "#{link_to "Edit Credits", "#{admin_todos_los_cliente_path(user.id)}/edit"} " if not user.linked
      if user.purchases.empty?
        links += "#{link_to "Delete", admin_todos_los_cliente_path(user.id), method: :delete, data: {:confirm => "Eliminarás al usuario. ¿Estás seguro?"} }"
      else
        links += (link_to "Purchases", "#{admin_compras_path}?q%5Buser_id_equals%5D=#{user.id}").to_s
      end
      links.html_safe
    end

  end

  form do |f|
    f.inputs "Modificación de créditos" do

      1.times do
        f.object.credit_modifications.build if f.object.errors.messages.empty? 
      end
      f.fields_for :credit_modifications do |t|
        if t.object.new_record?
          t.inputs do
            t.input :pack, label: "Purchased pack", :collection => Pack.all.collect {|pack| [pack.classes, pack.id]}, :as => :select, input_html: { id: "pack_id", onchange: "if(!this.value){ $('#credit_id')[0].readOnly=false; $('#credit_id')[0].style = 'background-color: #FFFFFF;'} else {$('#credit_id').val(this.options[this.selectedIndex].text); $('#credit_id')[0].readOnly=true; $('#credit_id')[0].style = 'background-color: #d3d3d3;'}" }
            t.input :credits, :as => :number, input_html: {id: "credit_id"}
            t.input :reason, input_html: {id: "reason_id"}
          end
        end
      end

      f.input :classes_left, as: :hidden, input_html: {value: f.object.classes_left}
      f.actions
    end
  end
  
  csv do
    column "Nombre" do |user|
      user.first_name
    end
    column "Apellido" do |user|
      user.last_name
    end
    column "Email" do |user|
      user.email
    end
  end

end
