# To test:
# 1. Should be able to add extra arguments after attributes in a subclass
# 2. Should throw an error if hash is not provided as FIRST argument

module Materialize
  class Entity

    def self.wrap(entities_data)
      entities_data.map { |entity_data| new(entity_data) }
    end

    def initialize(attributes)
      raise "Attributes must be a hash" unless attributes.is_a?(Hash)

      attributes.each_pair do |key, value|
        instance_variable_set("@#{key}", value)

        (class << self; self; end).class_eval do
          attr_reader key.to_sym
        end
      end
    end

  end
end
