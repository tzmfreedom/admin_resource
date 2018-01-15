require 'admin_resource/active_record/helper_methods'

module AdminResource
  module ActiveRecord
    module DecorateMethods
      def self.included(base)
        base.extend ClassMethods
      end

      def decorate
        extend AdminResource::ActiveRecord::HelperMethods
      end

      module ClassMethods
        def decorate_each(&block)
          all.each do |record|
            record.decorate
            yield record
          end
        end
      end
    end
  end
end