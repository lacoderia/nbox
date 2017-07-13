ActiveAdmin.register Purchase, :as => "Compras" do

  actions :all, :except => [:show, :new, :destroy, :update, :edit]

  filter :user_last_name, :label => "Apellido de cliente", :as => :string
  filter :created_at, :label => "Fecha"
  filter :amount, :label => "Precio"

  FILTERS = ["user_last_name", "created_at", "amount", "user_id"]

  config.sort_order = "created_at_desc"

  controller do
    def scoped_collection
      Purchase.with_users
    end
    
    def destroy
      super do |success,failure|
        redirect_path = admin_compras_path
        
        counter = 1
        params.each do |k, v|

          FILTERS.each do |filter|

            if k.include? filter
              if counter == 1 
                redirect_path += "?utf8=%E2%9C%93&q%5B#{k}=#{v}"
              else
                redirect_path += "&#{k}=#{v}"
              end
              counter += 1
            end
          end
        end
        success.html { redirect_to redirect_path }
      end
    end
  end

  index :title => "Compras" do
    column "Cliente" do |purchase|
      "#{purchase.user.first_name} #{purchase.user.last_name}"
    end

    column "Paquete" do |purchase|
      "#{purchase.pack.description}"
    end

    column "Precio" do |purchase|
      purchase.amount / 100.0
    end

    column "Fecha", :created_at 

    actions defaults: false do |purchase|
      link_path = admin_compra_path(purchase.id)
      if params[:q]
        counter = 1
        params[:q].each do |k, v|
          if counter == 1
            link_path += "?#{k}=#{v}"
          else
            link_path += "&#{k}=#{v}"
          end
          counter += 1
        end
      end
        link_to "Delete", link_path, method: :delete, data: {:confirm => "Eliminarás esta compra. ¿Estás seguro?"}
    end

  end

  
end
