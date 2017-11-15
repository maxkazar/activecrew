module ActiveCrew
  module Extender
    def command_context
      @command_context ||= {}
    end

    def command(name, options = {})
      context = { options: options }
      context[:session] = request.headers['x-session-token'] if respond_to? :request

      ActiveCrew::Backends.enqueue name, current_user, context.merge(command_context)
    end
  end
end

ActionController::Base.include ActiveCrew::Extender
