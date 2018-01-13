module AdminResource
  module Helper
    def set_link_variables
      admin_show_path
      admin_index_path
      admin_edit_path
      admin_new_path
    end

    def admin_show_path
      return if @record.nil?
      helper_method_name = "admin_#{model_klass.name.underscore}_path"
      @admin_show_path = respond_to?(helper_method_name) ? send(helper_method_name, @record.id) : nil
    end

    def admin_index_path
      helper_method_name = "admin_#{model_klass.name.pluralize.underscore}_path"
      @admin_index_path = respond_to?(helper_method_name) ? send(helper_method_name) : nil
    end

    def admin_edit_path
      return if @record.nil?
      helper_method_name = "edit_admin_#{model_klass.name.underscore}_path"
      @admin_edit_path = respond_to?(helper_method_name) ? send(helper_method_name, @record.id) : nil
    end

    def admin_new_path
      helper_method_name = "new_admin_#{model_klass.name.underscore}_path"
      @admin_new_path = respond_to?(helper_method_name) ? send(helper_method_name) : nil
    end

    def model_klass
      @model_klass ||= controller_name.classify.constantize
    end
  end
end