module Materialize
  class BaseBuilder
    extend Concurrent
    class << self

      def build(data, repo, options)
        entity = entity_class.new(data)
        entity.__builder_info__ = { repo: repo, options: options }
        entity
      end

      def build_all(data, repo, options)
        entity_class.wrap(data)
      end

      def entity_class
        "Entities::#{entity_base_class_name}".split('::').reduce(Module, :const_get)
      end

      private

      def entity_base_class_name
        "#{self.name[0..-8]}".split('::').last
      end

    end
  end
end
