# frozen_string_literal: true

#
# class Admin::HogeController
#   include AdminResource
#   actions :index
#   permit_params :name
# end

require 'active_support/concern'
require 'admin_resource/helper'
require 'admin_resource/version'

module AdminResource
  include ::AdminResource::Helper
  extend ::ActiveSupport::Concern

  # before_action :authenticate
  included do
    before_action :set_record, only: %i[show edit update]
    before_action :set_link_variables

    helper_method :record_path, :records_path, :new_record_path,
                  :edit_record_path, :record, :records,
                  :list_fields, :show_fields, :search_fields, :model_klass
  end

  DSL_METHODS = %W[permitted_fields show_fields list_fields search_fields eager_load]

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

  class_methods do
    ACTIONS = %W[new create index show edit update destroy]

    DSL_METHODS.each do |method|
      define_method(method) do |fields = nil|
        if fields
          instance_variable_set(:"@#{method}", fields)
        else
          instance_variable_get(:"@#{method}")
        end
      end
    end

    def actions(*actions)
      actions.reject! { |action| ACTIONS.include?(action) }
      actions.each { |action| send("define_#{action}") }
    end

    def define_new
      define_method(:new) do
        @record = model_klass.new
        render 'admin/shared/new'
      end
    end

    def define_create
      define_method(:create) do
        @record = model_klass.new(record_params)
        if @record.save
          redirect_to record_path(record.id)
        else
          render 'admin/shared/new'
        end
      end
    end

    def define_index
      define_method(:index) do
        relation = model_klass.all
        relation = relation.eager_load(eager_load) if eager_load
        @q = relation.search(params[:q])
        @records = paginate(relation: @q.result(distinct: true))
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
  end
end
