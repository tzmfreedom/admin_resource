module AdminResource
  module Helper
    def record_path(id)
      helper_method_name = "admin_#{model_klass.name.underscore}_path"
      respond_to?(helper_method_name) ? send(helper_method_name, id) : nil
    end

    def records_path
      helper_method_name = "admin_#{model_klass.name.pluralize.underscore}_path"
      respond_to?(helper_method_name) ? send(helper_method_name) : nil
    end

    def edit_record_path(id)
      helper_method_name = "edit_admin_#{model_klass.name.underscore}_path"
      respond_to?(helper_method_name) ? send(helper_method_name, id) : nil
    end

    def new_record_path
      helper_method_name = "new_admin_#{model_klass.name.underscore}_path"
      respond_to?(helper_method_name) ? send(helper_method_name) : nil
    end

    def record
      @record ||= instance_variable_get(:"#{record_instance_variable_name}")
    end

    def records
      @records ||= instance_variable_get(:"#{records_instance_variable_name}")
    end

    def model_klass
      @model_klass ||= controller_name.classify.constantize
    end
  end
end