module Materialize
  class Repo

    attr_reader :token

    def initialize(token = nil)
      @token = token
    end

    def method_missing(query, *args, &block)
      data_source_class = args[0]
      options           = args[1] || {}
      args_to_pass      = options[:args]

      data, builder_class = process(data_source_class, query, args_to_pass)
      options.delete(:args)
      options[:repo] = self
      options[:token] = token unless token.nil?

      if data.is_a?(Array)
        builder_class.build_all(data, options)
      else
        builder_class.build(data, options)
      end
    end

    private

    def process(data_source_class, query, args_to_pass)
      data = get_data(data_source_class, query, args_to_pass)
      builder_class = builder_class_for builder_class_name_for base_class_name_for data_source_class
      return data, builder_class
    end

    def builder_class_for(builder_class_name)
      if class_exists?(builder_class_name)
        Module.const_get(builder_class_name)
      else
        Object.const_set(builder_class_name, Class.new(Materialize::BaseBuilder))
      end
    end

    def builder_class_name_for(base_class_name)
      "#{base_class_name}Builder"
    end

    def base_class_name_for(data_source_class)
      data_source_class.name.split('::').last
    end

    def get_data(data_source_class, query, args_to_pass)
      if token.nil?

        if args_to_pass.nil?
          data_source_class.send(query)
        elsif args_to_pass.is_a?(Array)
          data_source_class.send(query, *args_to_pass)
        else
          data_source_class.send(query, args_to_pass)
        end

      else

        if args_to_pass.nil?
          data_source_class.send(query, token)
        elsif args_to_pass.is_a?(Array)
          data_source_class.send(query, token, *args_to_pass)
        else
          data_source_class.send(query, token, args_to_pass)
        end

      end
    end

    def class_exists?(class_name)
      klass = Module.const_get(class_name)
      return klass.is_a?(Class)
    rescue NameError
      return false
    end

  end
end
