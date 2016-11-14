module ActiveCrew
  module Chainable
    def chain
      @chain ||= @context[:chain] || []
    end

    def commands(*args)
      options = args.extract_options!
      add_to_chain args
      execute_chain options
    end

    def execute
      super
      execute_chain
    end

    private

    def add_to_chain(commands)
      chain.concat commands
    end

    def execute_chain(options = nil)
      return unless chain.present?

      name = chain.shift
      if name.is_a? Array
        name.each { |name| command name, options }
      else
        command name, options, chain: chain
      end
    end
  end
end
