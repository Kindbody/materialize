require 'pry'

module Materialize
  class Entity
    include Utils

    def self.wrap(entities_data)
      entities_data.map { |entity_data| new(entity_data) }
    end

    def initialize(attributes)
      raise "Attributes must be a hash" unless attributes.is_a?(Hash)

      attributes.each_pair do |key, value|

        # if the key of a collection can be converted to an entity class
        # -> do it

        if collection?(value)
          value = attempt_entity_conversion(key, value)
        end

        instance_variable_set("@#{key}", value)

        (class << self; self; end).class_eval do
          attr_reader key.to_sym
        end
      end
    end

    private

    def collection?(value)
      value.is_a? Enumerable
    end

    def attempt_entity_conversion(key, value)
      if class_exists?(covert_to_entity_class_name(key))
        Module.const_get(builder_class_name_for(key)).build_all(value, repo, options)
      else
        value
      end
    end

    def covert_to_entity_class_name(key)
      "Entities::#{base_name_for(key)}"
    end

    def builder_class_name_for(key)
      "#{base_name_for(key)}Builder"
    end

    def base_name_for(key)
      key.to_s.singularize.split('_').collect(&:capitalize).join
    end

  end
end
