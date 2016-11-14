module ActiveCrew
  module Commandable
    def command(name, options = {}, context = {})
      Backends.enqueue name, invoker, @context.merge(options: options).merge(context)
    end

    def backend
      Backends.default
    end
  end
end
