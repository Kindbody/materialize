module Materialize
  class Repo

    def method_missing(query, *args, &block)
      data_source_class = args[0]
      options           = args[1] || {}
      args_to_pass      = options[:args]

      data, entity_class = process(data_source_class, query, args_to_pass)

      if data.is_a?(Array)
        entity_class.wrap(data)
      else
        entity_class.new(data)
      end
    end

    private

    def process(data_source_class, query, args_to_pass)
      data = get_data(data_source_class, query, args_to_pass)
      entity_class = entity_class_for entity_class_name_for base_class_name_for data_source_class
      return data, entity_class
    end

    def entity_class_for(entity_class_name)
      entity_class_name.split('::').reduce(Module, :const_get)
    end

    def entity_class_name_for(base_class_name)
      "Entities::#{base_class_name}"
    end

    def base_class_name_for(data_source_class)
      data_source_class.name.split('::').last
    end

    def get_data(data_source_class, query, args_to_pass)
      if args_to_pass.nil?
        data_source_class.send(query)
      elsif args_to_pass.is_a?(Array)
        data_source_class.send(query, *args_to_pass)
      else
        data_source_class.send(query, args_to_pass)
      end
    end

  end
end
