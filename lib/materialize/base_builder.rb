module Materialize
  class BaseBuilder
    class << self

      def build(data, options)
        entity_class.new(data)
      end

      def build_all(data, options)
        entity_class.wrap(data)
      end

      def concurrent(*lambdas)
        threads = []
        lambdas.each do |l|
          threads << Thread.new do
            l.()
          end
        end
        threads.each(&:join)
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
