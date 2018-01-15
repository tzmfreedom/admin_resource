require 'admin_resource/active_record/decorate_methods'

module AdminResource
  class Railtie < ::Rails::Engine
    initializer 'admin_resource' do
      ActiveSupport.on_load :active_record do
        ::ActiveRecord::Base.include ::AdminResource::ActiveRecord::DecorateMethods
      end
    end
  end
end