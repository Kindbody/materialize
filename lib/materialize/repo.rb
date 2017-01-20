module Materialize
  class Repo

    def method_missing(query, *args, &block)
      data_source = args[0]
      data_source.send(query)
    end

  end
end
