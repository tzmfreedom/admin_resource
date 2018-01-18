module AdminResource
  module ActiveRecord
    module HelperMethods
      def self.url_helper_proxy
        @url_helper_proxy ||= Class.new do
          include Rails.application.routes.url_helpers
        end.new
      end

      def url_helper_proxy
        ::AdminResource::ActiveRecord::HelperMethods.url_helper_proxy
      end

      def admin_index_path
        url_helper_proxy.send("admin_#{model_name.plural}_path")
      end

      def admin_show_path
        url_helper_proxy.send("admin_#{model_name.singular}_path", id)
      end

      def admin_new_path
        url_helper_proxy.send("new_admin_#{model_name.singular}_path")
      end

      def admin_edit_path
        url_helper_proxy.send("edit_admin_#{model_name.singular}_path", id)
      end

      def display_attribute(attribute)
        value = send(attribute)
        convert_to_display(value)
      end

      def convert_to_display(value)
        return super if defined?(super)

        value.class == ::ActiveSupport::TimeWithZone ? I18n.l(value) : value
      end
    end
  end
end