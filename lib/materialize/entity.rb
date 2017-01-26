module Materialize
  class Entity
    include Utils

    def self.wrap(entities_data)
      entities_data.map { |entity_data| new(entity_data) }
    end

    attr_writer :__builder_info__

    def initialize(attributes)
      raise "Attributes must be a hash" unless attributes.is_a?(Hash)

      @__repo__    = attributes[:__repo__]
      @__options__ = attributes[:__options__]

      attributes.delete(:__repo__)
      attributes.delete(:__options__)

      attributes.each_pair do |key, value|
        value = attempt_entity_conversion(key, value) if collection?(value)
        instance_variable_set("@#{key}", value)
        (class << self; self; end).class_eval do
          attr_reader key.to_sym
        end
      end
    end

    private

    # START REMARKS ---->

    # __repo__ and __options__ are here to allow for nested data coming from a data source via a repo.
    # e.g.
    # blog_post = {
    #   id: 1,
    #   title: 'TDD is dead (wait, what?)'
    #   ...
    #   comments: [...]
    # }
    #
    # In this case, we need to queue a builder, which requires a repo and options (see repo & builder classes).
    # WARNING:
    # This should be avoided for deeply nested data, especially when the leaves look up extra data!

    attr_reader :__repo__, :__options__

    def attempt_entity_conversion(key, value)
      if class_exists?(covert_to_entity_class_name(key))
        Module.const_get(builder_class_name_for(key)).build_all(value, __repo__, __options__)
      else
        value
      end
    end

    # ----> END REMARKS

    def collection?(value)
      value.is_a? Enumerable
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
