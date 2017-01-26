module Materialize
  class BaseBuilder
    extend Concurrent
    class << self

      def build(data, repo, options)
        attach_builder_info(entity_class.new(data), repo, options)
      end

      def build_all(data, repo, options)
        entity_class.wrap(data).map { |entity| attach_builder_info(entity, repo, options) }
      end

      def entity_class
        "Entities::#{entity_base_class_name}".split('::').reduce(Module, :const_get)
      end

      private

      def attach_builder_info(entity, repo, options)
        entity.__builder_info__ = { repo: repo, options: options }
        entity
      end

      def entity_base_class_name
        "#{self.name[0..-8]}".split('::').last
      end

    end
  end
end
