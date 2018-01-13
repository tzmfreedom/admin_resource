# frozen_string_literal: true

#
# class Admin::HogeController
#   include AdminResource
#   actions :index
#   permit_params :name
# end

require 'active_support/concern'
require 'admin_resource/railtie'
require 'admin_resource/helper'
require 'admin_resource/version'
require 'ransack'
require 'kaminari'

module AdminResource
  include ::AdminResource::Helper
  extend ::ActiveSupport::Concern

  # before_action :authenticate
  included do
    before_action :set_record, only: %i[show edit update]
    before_action :set_link_variables

    helper_method :model_klass
  end

  def record_params
    params.require(:"#{model_klass.name.underscore}").permit(*permitted_fields)
  end

  def set_record
    relation = model_klass
    relation = relation.eager_load(eager_load) if eager_load
    @record = relation.find(params[:id])
  end

  DSL_METHODS = %W[permitted_fields show_fields list_fields search_fields eager_load]

  DSL_METHODS.each do |method|
    define_method(method) do
      self.class.send(method)
    end
  end

  class_methods do
    ACTIONS = %W[new create index show edit update destroy]
    PER_PAGE = 30

    DSL_METHODS.each do |method|
      define_method(method) do |*fields|
        if fields.blank?
          instance_variable_get(:"@#{method}")
        else
          instance_variable_set(:"@#{method}", fields)
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
          redirect_to @admin_show_path
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
        @records = @q.result(distinct: true).page(params[:page]).per(PER_PAGE)
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
          redirect_to @admin_show_path
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
        redirect_to @admin_index_path
      end
    end
  end
end
