module Restaurant
  module Actions
    def self.included(base)
      base.before_filter :require_valid_id, :require_resource, :only => [:show, :update, :destroy]
      base.before_filter :add_created_at, :only => :create
      base.before_filter :add_updated_at, :only => :update
      base.after_filter :expire_resource_cache, :only => [:update, :destroy]
      base.after_filter :update_resources_version_cache, :only => [:create, :update, :destroy]
    end

    def index
      respond_with resources
    end

    def show
      respond_with resource
    end

    def create
      collection.insert(resource_params.merge(:_id => resource_id))
      respond_with collection.find(:_id => resource_id).first, :location => { :action => :show, :id => resource_id }
    end

    def update
      respond_with collection.find(:_id => resource_id).update(:$set => resource_params)
    end

    def destroy
      respond_with collection.find(:_id => resource_id).remove_all
    end

    private

    def require_valid_id
      head 404 unless Moped::BSON::ObjectId.legal?(params[:id])
    end

    def require_resource
      head 404 unless resource
    end

    def collection
      Mongoid.default_session[resources_name]
    end

    def resource
      @resource ||= collection.find(:_id => resource_id).first
    end

    def resources
      collection.find(filter_params).sort(sort_params).skip(skip_params).limit(limit_params).to_a
    end

    def resources_with_cache
      if cache_configured?
        cache_store.fetch(resources_cache_key) do
          resources_without_cache
        end
      else
        resources_without_cache
      end
    end
    alias_method_chain :resources, :cache

    def resource_with_cache
      if cache_configured?
        cache_store.fetch(resource_cache_key) do
          resource_without_cache
        end
      else
        resource_without_cache
      end
    end
    alias_method_chain :resource, :cache

    def resource_name
      resources_name.singularize
    end

    def resources_name
      params[:resource]
    end

    def resource_params
      @resource_params ||= params[resource_name] || {}
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

    def filter_params
      params[:filter] || {}
    end

    def sort_params
      Hash[(params[:sort] || []).map {|key, value| [key, value.to_i] }]
    end

    def skip_params
      ([params[:page].to_i, 1].max - 1) * per_page
    end

    def limit_params
      per_page
    end

    def per_page
      10
    end

    def add_created_at
      resource_params[:created_at] = resource_params[:updated_at] = Time.now
    end

    def add_updated_at
      resource_params[:updated_at] = Time.now
    end

    def expire_resource_cache
      cache_store.delete(resource_cache_key) if cache_configured?
    end

    def resource_cache_key
      params.slice(:resource, :id)
    end

    def resources_version_cache_key
      { :resource => params[:resource] }
    end

    def update_resources_version_cache
      if cache_configured?
        cache_store.write(resources_version_cache_key, Time.now.to_f)
      end
    end

    def resources_version
      cache_store.read(resources_version_cache_key)
    end

    def resources_cache_key
      params.slice(:resource, :filter, :sort, :page).merge(:version => resources_version)
    end
  end
end
