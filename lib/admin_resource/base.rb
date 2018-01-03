module AdminResource
  class Base < Module
    extend ActiveSupport::Concern

    included do
      # before_action :authenticate
      before_action :set_record, only: %i[show edit update]

      helper_method :record_path, :records_path, :new_record_path,
                    :edit_record_path, :record, :records,
                    :list_fields, :show_fields, :search_fields, :model_klass
    end

    def initialize(*actions)
      define_index   if actions.include?(:index)
      define_show    if actions.include?(:show)
      define_new     if actions.include?(:new)
      define_create  if actions.include?(:create)
      define_edit    if actions.include?(:edit)
      define_update  if actions.include?(:update)
      define_destroy if actions.include?(:destroy)
    end

    def included(descendant)
      super
      descendant.send(:include, Methods)
    end


    def define_new
      define_method(:new) do
        instance_variable_set(:"#{record_instance_variable_name}", model_klass.new)
        render 'admin/shared/new'
      end
    end

    def define_create
      define_method(:create) do
        record = instance_variable_set(:"#{record_instance_variable_name}", model_klass.new(record_params))
        if record.save
          redirect_to record_path(record.id)
        else
          render 'admin/shared/new'
        end
      end
    end

    def define_index
      define_method(:index) do
        records = model_klass.all
        records = records.eager_load(eager_load) if eager_load
        @q = records.search(params[:q])
        instance_variable_set(:"#{records_instance_variable_name}", paginate(relation: @q.result(distinct: true)))
        render 'admin/shared/index' if list_fields
      end
    end

    def define_show
      define_method(:show) do
        render 'admin/shared/show' if show_fields
      end
    end

    def define_update
      define_method(:update) do
        if record.update(record_params)
          redirect_to record_path(record.id)
        else
          render 'admin/shared/edit'
        end
      end
    end

    def define_edit
      define_method(:edit) do
        render 'admin/shared/edit'
      end
    end

    def define_destroy
      define_method(:destroy) do
        record.destroy
        redirect_to records_path
      end
    end

    DSL_METHODS = %W[permitted_fields show_fields list_fields search_fields eager_load]
    module ClassMethods
      DSL_METHODS.each do |method|
        define_method(method) do |fields = nil|
          if fields
            instance_variable_set(:"@#{method}", fields)
          else
            instance_variable_get(:"@#{method}")
          end
        end
      end
    end

    module Methods
      include ::AdminResource::Helper

      DSL_METHODS.each do |method|
        define_method(method) do
          self.class.send(method)
        end
      end

      def record_params
        params.require(:"#{model_klass.name.underscore}").permit(*permitted_fields)
      end

      def set_record
        relation = model_klass
        relation = relation.eager_load(eager_load) if eager_load
        record = relation.find(params[:id])
        instance_variable_set(:"#{record_instance_variable_name}", record)
      end

      def record_instance_variable_name
        "@#{model_klass.name.underscore}"
      end

      def records_instance_variable_name
        "@#{model_klass.name.underscore.pluralize}"
      end
    end
  end
end
