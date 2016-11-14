module ActiveCrew
  class CommandError < Exception; end

  module Respondable
    def respond_with(model)
      Responders.respond_with name, invoker, context, model
    end

    def respond_fail(*args)
      fail CommandError, I18n.t(*args)
    end

    def execute
      super
    rescue Interrupt
      raise
    rescue CommandError
      respond_with $ERROR_INFO
    end
  end
end
