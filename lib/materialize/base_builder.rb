module Materialize
  class BaseBuilder
    class << self

      def build(data)
        Entities::Zombie.new(data)
      end

      def build_all(data)
        Entities::Zombie.wrap(data)
      end

    end
  end
end
