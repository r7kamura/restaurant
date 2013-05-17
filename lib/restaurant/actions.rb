module Restaurant
  module Actions
    def index
      respond_with collection.find
    end

    def show
      respond_with collection.find(:_id => resource_id).first
    end

    def create
      collection.insert(resource_param.merge(:_id => resource_id))
      respond_with collection.find(:_id => resource_id).first, :location => { :action => :show, :id => resource_id }
    end

    def update
      respond_with collection.find(:_id => resource_id).update(:$set => resource_param)
    end

    def destroy
      respond_with collection.find(:_id => resource_id).remove_all
    end

    private

    def collection
      Mongoid.default_session.with(:safe => true)[resources_name]
    end

    def resource_name
      resources_name.singularize
    end

    def resources_name
      params[:resource]
    end

    def resource_param
      params[resource_name]
    end

    def resource_id
      @resource_id ||= begin
        if params[:id]
          Moped::BSON::ObjectId.from_string(params[:id])
        else
          Moped::BSON::ObjectId.new
        end
      end
    end
  end
end
